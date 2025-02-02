module Neo4j::ActiveNode
  module HasN
    extend ActiveSupport::Concern

    class NonPersistedNodeError < StandardError; end

    # Return this object from associations
    # It uses a QueryProxy to get results
    # But also caches results and can have results cached on it
    class AssociationProxy
      def initialize(query_proxy, cached_result = nil)
        @query_proxy = query_proxy
        cache_result(cached_result)

        # Represents the thing which can be enumerated
        # default to @query_proxy, but will be set to
        # @cached_result if that is set
        @enumerable = @query_proxy
      end

      # States:
      # Default
      def inspect
        if @cached_result
          @cached_result.inspect
        else
          "<AssociationProxy @query_proxy=#{@query_proxy.inspect}>"
        end
      end

      extend Forwardable
      %w(include? empty? count find ==).each do |delegated_method|
        def_delegator :@enumerable, delegated_method
      end

      include Enumerable

      def each(&block)
        result.each(&block)
      end

      def result
        return @cached_result if @cached_result

        cache_query_proxy_result

        @cached_result
      end

      def cache_result(result)
        @cached_result = result
        @enumerable = (@cached_result || @query_proxy)
      end

      def cache_query_proxy_result
        @query_proxy.to_a.tap do |result|
          result.each do |object|
            object.instance_variable_set('@association_proxy', self)
          end
          cache_result(result)
        end
      end

      def clear_cache_result
        cache_result(nil)
      end

      def cached?
        !!@cached_result
      end

      QUERY_PROXY_METHODS = [:<<, :delete]
      CACHED_RESULT_METHODS = []

      def method_missing(method_name, *args, &block)
        target = target_for_missing_method(method_name)
        super if target.nil?

        cache_query_proxy_result if !cached? && !target.is_a?(Neo4j::ActiveNode::Query::QueryProxy)
        clear_cache_result if target.is_a?(Neo4j::ActiveNode::Query::QueryProxy)

        target.public_send(method_name, *args, &block)
      end

      private

      def target_for_missing_method(method_name)
        case method_name
        when *QUERY_PROXY_METHODS
          @query_proxy
        when *CACHED_RESULT_METHODS
          @cached_result
        else
          if @cached_result && @cached_result.respond_to?(method_name)
            @cached_result
          elsif @query_proxy.respond_to?(method_name)
            @query_proxy
          end
        end
      end
    end

    # Returns the current AssociationProxy cache for the association cache. It is in the format
    # { :association_name => AssociationProxy}
    # This is so that we
    # * don't need to re-build the QueryProxy objects
    # * also because the QueryProxy object caches it's results
    # * so we don't need to query again
    # * so that we can cache results from association calls or eager loading
    def association_proxy_cache
      @association_proxy_cache ||= {}
    end

    def association_proxy_cache_fetch(key)
      association_proxy_cache.fetch(key) do
        value = yield
        association_proxy_cache[key] = value
      end
    end

    def association_query_proxy(name, options = {})
      self.class.send(:association_query_proxy, name, {start_object: self}.merge!(options))
    end

    def association_proxy(name, options = {})
      name = name.to_sym
      hash = [name, options.values_at(:node, :rel, :labels, :rel_length)].hash
      association_proxy_cache_fetch(hash) do
        if previous_association_proxy = self.instance_variable_get('@association_proxy')
          result_by_previous_id = previous_association_proxy_results_by_previous_id(previous_association_proxy, name)

          previous_association_proxy.result.inject(nil) do |proxy_to_return, object|
            proxy = fresh_association_proxy(name, options, result_by_previous_id[object.neo_id])

            object.association_proxy_cache[hash] = proxy

            (self == object ? proxy : proxy_to_return)
          end
        else
          fresh_association_proxy(name, options)
        end
      end
    end

    private

    def fresh_association_proxy(name, options = {}, cached_result = nil)
      AssociationProxy.new(association_query_proxy(name, options), cached_result)
    end

    def previous_association_proxy_results_by_previous_id(association_proxy, association_name)
      query_proxy = self.class.as(:previous).where(neo_id: association_proxy.result.map(&:neo_id))
      query_proxy = self.class.send(:association_query_proxy, association_name, previous_query_proxy: query_proxy, node: :next)

      Hash[*query_proxy.pluck('ID(previous)', 'collect(next)').flatten(1)]
    end

    module ClassMethods
      # :nocov:
      # rubocop:disable Style/PredicateName
      def has_association?(name)
        ActiveSupport::Deprecation.warn 'has_association? is deprecated and may be removed from future releases, use association? instead.', caller

        association?(name)
      end
      # rubocop:enable Style/PredicateName
      # :nocov:

      def association?(name)
        !!associations[name.to_sym]
      end

      def associations
        @associations ||= {}
      end

      def associations_keys
        @associations_keys ||= associations.keys
      end

      # make sure the inherited classes inherit the <tt>_decl_rels</tt> hash
      def inherited(klass)
        klass.instance_variable_set(:@associations, associations.clone)
        @associations_keys = klass.associations_keys.clone
        super
      end

      # For defining an "has many" association on a model.  This defines a set of methods on
      # your model instances.  For instance, if you define the association on a Person model:
      #
      # has_many :out, :vehicles, type: :has_vehicle
      #
      # This would define the following methods:
      #
      # **#vehicles**
      #   Returns a QueryProxy object.  This is an Enumerable object and thus can be iterated
      #   over.  It also has the ability to accept class-level methods from the Vehicle model
      #   (including calls to association methods)
      #
      # **#vehicles=**
      #   Takes an array of Vehicle objects and replaces all current ``:HAS_VEHICLE`` relationships
      #   with new relationships refering to the specified objects
      #
      # **.vehicles**
      #   Returns a QueryProxy object.  This would represent all ``Vehicle`` objects associated with
      #   either all ``Person`` nodes (if ``Person.vehicles`` is called), or all ``Vehicle`` objects
      #   associated with the ``Person`` nodes thus far represented in the QueryProxy chain.
      #   For example:
      #     ``company.people.where(age: 40).vehicles``
      #
      # Arguments:
      #   **direction:**
      #     **Available values:** ``:in``, ``:out``, or ``:both``.
      #
      #     Refers to the relative to the model on which the association is being defined.
      #
      #     Example:
      #       ``Person.has_many :out, :posts, type: :wrote``
      #
      #         means that a `WROTE` relationship goes from a `Person` node to a `Post` node
      #
      #   **name:**
      #     The name of the association.  The affects the methods which are created (see above).
      #     The name is also used to form default assumptions about the model which is being referred to
      #
      #     Example:
      #       ``Person.has_many :out, :posts, type: :wrote``
      #
      #       will assume a `model_class` option of ``'Post'`` unless otherwise specified
      #
      #   **options:** A ``Hash`` of options.  Allowed keys are:
      #     *type*: The Neo4j relationship type.  This option is required unless either the
      #       `origin` or `rel_class` options are specified
      #
      #     *origin*: The name of the association from another model which the `type` and `model_class`
      #       can be gathered.
      #
      #       Example:
      #         ``Person.has_many :out, :posts, origin: :author`` (`model_class` of `Post` is assumed here)
      #
      #         ``Post.has_one :in, :author, type: :has_author, model_class: 'Person'``
      #
      #     *model_class*: The model class to which the association is referring.  Can be either a
      #       model object ``include`` ing ``ActiveNode`` or a string (or an ``Array`` of same).
      #       **A string is recommended** to avoid load-time issues
      #
      #     *rel_class*: The ``ActiveRel`` class to use for this association.  Can be either a
      #       model object ``include`` ing ``ActiveRel`` or a string (or an ``Array`` of same).
      #       **A string is recommended** to avoid load-time issues
      #
      #     *dependent*: Enables deletion cascading.
      #       **Available values:** ``:delete``, ``:delete_orphans``, ``:destroy``, ``:destroy_orphans``
      #       (note that the ``:destroy_orphans`` option is known to be "very metal".  Caution advised)
      #
      def has_many(direction, name, options = {}) # rubocop:disable Style/PredicateName
        name = name.to_sym
        build_association(:has_many, direction, name, options)

        define_has_many_methods(name)
      end

      # For defining an "has one" association on a model.  This defines a set of methods on
      # your model instances.  For instance, if you define the association on a Person model:
      #
      # has_one :out, :vehicle, type: :has_vehicle
      #
      # This would define the methods: ``#vehicle``, ``#vehicle=``, and ``.vehicle``.
      #
      # See :ref:`#has_many <Neo4j/ActiveNode/HasN/ClassMethods#has_many>` for anything
      # not specified here
      #
      def has_one(direction, name, options = {}) # rubocop:disable Style/PredicateName
        name = name.to_sym
        build_association(:has_one, direction, name, options)

        define_has_one_methods(name)
      end

      private

      def define_has_many_methods(name)
        define_method(name) do |node = nil, rel = nil, options = {}|
          # return [].freeze unless self._persisted_obj

          if node.is_a?(Hash)
            options = node
            node = nil
          end

          association_proxy(name, {node: node, rel: rel, source_object: self, labels: options[:labels]}.merge!(options))
        end

        define_has_many_setter(name)

        define_class_method(name) do |node = nil, rel = nil, options = {}|
          association_proxy(name, {node: node, rel: rel, labels: options[:labels]}.merge!(options))
        end
      end

      def define_has_many_setter(name)
        define_method("#{name}=") do |other_nodes|
          association_proxy_cache.clear

          Neo4j::Transaction.run { association_proxy(name).replace_with(other_nodes) }
        end
      end

      def define_has_one_methods(name)
        define_has_one_getter(name)

        define_has_one_setter(name)

        define_class_method(name) do |node = nil, rel = nil, options = {}|
          association_proxy(name, {node: node, rel: rel, labels: options[:labels]}.merge!(options))
        end
      end

      def define_has_one_getter(name)
        define_method(name) do |node = nil, rel = nil, options = {}|
          return nil unless self._persisted_obj

          if node.is_a?(Hash)
            options = node
            node = nil
          end

          # Return all results if a variable-length relationship length was given
          results = association_proxy(name, {node: node, rel: rel}.merge!(options))
          if options[:rel_length] && !options[:rel_length].is_a?(Fixnum)
            results
          else
            results.first
          end
        end
      end

      def define_has_one_setter(name)
        define_method("#{name}=") do |other_node|
          if persisted?
            other_node.save if other_node.respond_to?(:persisted?) && !other_node.persisted?
            association_proxy_cache.clear # TODO: Should probably just clear for this association...
            Neo4j::Transaction.run { association_proxy(name).replace_with(other_node) }
            # handle_non_persisted_node(other_node)
          else
            association_proxy(name).defer_create(other_node, {}, :'=')
          end
        end
      end

      def define_class_method(*args, &block)
        klass = class << self; self; end
        klass.instance_eval do
          define_method(*args, &block)
        end
      end

      def association_query_proxy(name, options = {})
        previous_query_proxy = options[:previous_query_proxy] || current_scope
        query_proxy = previous_query_proxy || default_association_query_proxy
        Neo4j::ActiveNode::Query::QueryProxy.new(association_target_class(name),
                                                 associations[name],
                                                 {session: neo4j_session,
                                                  query_proxy: query_proxy,
                                                  context: "#{query_proxy.context || self.name}##{name}",
                                                  optional: query_proxy.optional?,
                                                  association_labels: options[:labels],
                                                  source_object: query_proxy.source_object}.merge!(options)).tap do |query_proxy_result|
                                                    target_classes = association_target_classes(name)
                                                    return query_proxy_result.as_models(target_classes) if target_classes
                                                  end
      end

      def association_proxy(name, options = {})
        query_proxy = association_query_proxy(name, options)
        AssociationProxy.new(query_proxy)
      end

      def association_target_class(name)
        target_classes_or_nil = associations[name].target_classes_or_nil

        return if !target_classes_or_nil.is_a?(Array) || target_classes_or_nil.size != 1

        target_classes_or_nil[0]
      end

      def association_target_classes(name)
        target_classes_or_nil = associations[name].target_classes_or_nil

        return if !target_classes_or_nil.is_a?(Array) || target_classes_or_nil.size <= 1

        target_classes_or_nil
      end

      def default_association_query_proxy
        Neo4j::ActiveNode::Query::QueryProxy.new("::#{self.name}".constantize,
                                                 nil,
                                                 session: neo4j_session,
                                                 query_proxy: nil,
                                                 context: "#{self.name}")
      end

      def build_association(macro, direction, name, options)
        Neo4j::ActiveNode::HasN::Association.new(macro, direction, name, options).tap do |association|
          @associations ||= {}
          @associations[name] = association
          create_reflection(macro, name, association, self)
        end

        associations_keys << name

      # Re-raise any exception with added class name and association name to
      # make sure error message is helpful
      rescue StandardError => e
        raise e.class, "#{e.message} (#{self.class}##{name})"
      end
    end
  end
end
