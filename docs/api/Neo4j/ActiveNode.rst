ActiveNode
==========



Makes Neo4j nodes and relationships behave like ActiveRecord objects.
By including this module in your class it will create a mapping for the node to your ruby class
by using a Neo4j Label with the same name as the class. When the node is loaded from the database it
will check if there is a ruby class for the labels it has.
If there Ruby class with the same name as the label then the Neo4j node will be wrapped
in a new object of that class.

= ClassMethods
* {Neo4j::ActiveNode::Labels::ClassMethods} defines methods like: <tt>index</tt> and <tt>find</tt>
* {Neo4j::ActiveNode::Persistence::ClassMethods} defines methods like: <tt>create</tt> and <tt>create!</tt>
* {Neo4j::ActiveNode::Property::ClassMethods} defines methods like: <tt>property</tt>.


.. toctree::
   :maxdepth: 3
   :titlesonly:


   

   

   ActiveNode/Rels

   ActiveNode/Query

   ActiveNode/Scope

   ActiveNode/HasN

   ActiveNode/Labels

   ActiveNode/Property

   ActiveNode/Callbacks

   ActiveNode/Dependent

   ActiveNode/Initialize

   ActiveNode/Reflection

   ActiveNode/IdProperty

   ActiveNode/Validations

   ActiveNode/Persistence

   ActiveNode/Unpersisted

   ActiveNode/ClassMethods

   ActiveNode/OrmAdapter

   ActiveNode/QueryMethods




Constants
---------



  * WRAPPED_CLASSES

  * MODELS_FOR_LABELS_CACHE

  * USES_CLASSNAME



Files
-----



  * `lib/neo4j/active_node.rb:23 <https://github.com/neo4jrb/neo4j/blob/master/lib/neo4j/active_node.rb#L23>`_

  * `lib/neo4j/active_node/rels.rb:1 <https://github.com/neo4jrb/neo4j/blob/master/lib/neo4j/active_node/rels.rb#L1>`_

  * `lib/neo4j/active_node/query.rb:2 <https://github.com/neo4jrb/neo4j/blob/master/lib/neo4j/active_node/query.rb#L2>`_

  * `lib/neo4j/active_node/scope.rb:3 <https://github.com/neo4jrb/neo4j/blob/master/lib/neo4j/active_node/scope.rb#L3>`_

  * `lib/neo4j/active_node/has_n.rb:1 <https://github.com/neo4jrb/neo4j/blob/master/lib/neo4j/active_node/has_n.rb#L1>`_

  * `lib/neo4j/active_node/labels.rb:2 <https://github.com/neo4jrb/neo4j/blob/master/lib/neo4j/active_node/labels.rb#L2>`_

  * `lib/neo4j/active_node/property.rb:1 <https://github.com/neo4jrb/neo4j/blob/master/lib/neo4j/active_node/property.rb#L1>`_

  * `lib/neo4j/active_node/callbacks.rb:2 <https://github.com/neo4jrb/neo4j/blob/master/lib/neo4j/active_node/callbacks.rb#L2>`_

  * `lib/neo4j/active_node/dependent.rb:2 <https://github.com/neo4jrb/neo4j/blob/master/lib/neo4j/active_node/dependent.rb#L2>`_

  * `lib/neo4j/active_node/reflection.rb:1 <https://github.com/neo4jrb/neo4j/blob/master/lib/neo4j/active_node/reflection.rb#L1>`_

  * `lib/neo4j/active_node/id_property.rb:1 <https://github.com/neo4jrb/neo4j/blob/master/lib/neo4j/active_node/id_property.rb#L1>`_

  * `lib/neo4j/active_node/validations.rb:2 <https://github.com/neo4jrb/neo4j/blob/master/lib/neo4j/active_node/validations.rb#L2>`_

  * `lib/neo4j/active_node/persistence.rb:1 <https://github.com/neo4jrb/neo4j/blob/master/lib/neo4j/active_node/persistence.rb#L1>`_

  * `lib/neo4j/active_node/unpersisted.rb:2 <https://github.com/neo4jrb/neo4j/blob/master/lib/neo4j/active_node/unpersisted.rb#L2>`_

  * `lib/neo4j/active_node/orm_adapter.rb:4 <https://github.com/neo4jrb/neo4j/blob/master/lib/neo4j/active_node/orm_adapter.rb#L4>`_

  * `lib/neo4j/active_node/query_methods.rb:2 <https://github.com/neo4jrb/neo4j/blob/master/lib/neo4j/active_node/query_methods.rb#L2>`_

  * `lib/neo4j/active_node/has_n/association.rb:4 <https://github.com/neo4jrb/neo4j/blob/master/lib/neo4j/active_node/has_n/association.rb#L4>`_

  * `lib/neo4j/active_node/query/query_proxy.rb:2 <https://github.com/neo4jrb/neo4j/blob/master/lib/neo4j/active_node/query/query_proxy.rb#L2>`_

  * `lib/neo4j/active_node/query/query_proxy_link.rb:2 <https://github.com/neo4jrb/neo4j/blob/master/lib/neo4j/active_node/query/query_proxy_link.rb#L2>`_

  * `lib/neo4j/active_node/query/query_proxy_methods.rb:2 <https://github.com/neo4jrb/neo4j/blob/master/lib/neo4j/active_node/query/query_proxy_methods.rb#L2>`_

  * `lib/neo4j/active_node/query/query_proxy_enumerable.rb:2 <https://github.com/neo4jrb/neo4j/blob/master/lib/neo4j/active_node/query/query_proxy_enumerable.rb#L2>`_

  * `lib/neo4j/active_node/dependent/query_proxy_methods.rb:2 <https://github.com/neo4jrb/neo4j/blob/master/lib/neo4j/active_node/dependent/query_proxy_methods.rb#L2>`_

  * `lib/neo4j/active_node/query/query_proxy_unpersisted.rb:2 <https://github.com/neo4jrb/neo4j/blob/master/lib/neo4j/active_node/query/query_proxy_unpersisted.rb#L2>`_

  * `lib/neo4j/active_node/dependent/association_methods.rb:2 <https://github.com/neo4jrb/neo4j/blob/master/lib/neo4j/active_node/dependent/association_methods.rb#L2>`_

  * `lib/neo4j/active_node/query/query_proxy_eager_loading.rb:2 <https://github.com/neo4jrb/neo4j/blob/master/lib/neo4j/active_node/query/query_proxy_eager_loading.rb#L2>`_

  * `lib/neo4j/active_node/has_n/association_cypher_methods.rb:2 <https://github.com/neo4jrb/neo4j/blob/master/lib/neo4j/active_node/has_n/association_cypher_methods.rb#L2>`_

  * `lib/neo4j/active_node/query/query_proxy_find_in_batches.rb:2 <https://github.com/neo4jrb/neo4j/blob/master/lib/neo4j/active_node/query/query_proxy_find_in_batches.rb#L2>`_





Methods
-------



.. _`Neo4j/ActiveNode#==`:

**#==**
  

  .. hidden-code-block:: ruby

     def ==(other)
       other.class == self.class && other.id == id
     end



.. _`Neo4j/ActiveNode#[]`:

**#[]**
  Returning nil when we get ActiveAttr::UnknownAttributeError from ActiveAttr

  .. hidden-code-block:: ruby

     def read_attribute(name)
       super(name)
     rescue ActiveAttr::UnknownAttributeError
       nil
     end



.. _`Neo4j/ActiveNode#_create_node`:

**#_create_node**
  

  .. hidden-code-block:: ruby

     def _create_node(*args)
       session = self.class.neo4j_session
       props = self.class.default_property_values(self)
       props.merge!(args[0]) if args[0].is_a?(Hash)
       set_classname(props)
       labels = self.class.mapped_label_names
       session.create_node(props, labels)
     end



.. _`Neo4j/ActiveNode#_persisted_obj`:

**#_persisted_obj**
  Returns the value of attribute _persisted_obj

  .. hidden-code-block:: ruby

     def _persisted_obj
       @_persisted_obj
     end



.. _`Neo4j/ActiveNode#_rels_delegator`:

**#_rels_delegator**
  

  .. hidden-code-block:: ruby

     def _rels_delegator
       fail "Can't access relationship on a non persisted node" unless _persisted_obj
       _persisted_obj
     end



.. _`Neo4j/ActiveNode#add_label`:

**#add_label**
  adds one or more labels

  .. hidden-code-block:: ruby

     def add_label(*label)
       @_persisted_obj.add_label(*label)
     end



.. _`Neo4j/ActiveNode#apply_default_values`:

**#apply_default_values**
  

  .. hidden-code-block:: ruby

     def apply_default_values
       return if self.class.declared_property_defaults.empty?
       self.class.declared_property_defaults.each_pair do |key, value|
         self.send("#{key}=", value) if self.send(key).nil?
       end
     end



.. _`Neo4j/ActiveNode#as`:

**#as**
  Starts a new QueryProxy with the starting identifier set to the given argument and QueryProxy source_object set to the node instance.
  This method does not exist within QueryProxy and can only be used to start a new chain.

  .. hidden-code-block:: ruby

     def as(node_var)
       self.class.query_proxy(node: node_var, source_object: self).match_to(self)
     end



.. _`Neo4j/ActiveNode#association_proxy`:

**#association_proxy**
  

  .. hidden-code-block:: ruby

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



.. _`Neo4j/ActiveNode#association_proxy_cache`:

**#association_proxy_cache**
  Returns the current AssociationProxy cache for the association cache. It is in the format
  { :association_name => AssociationProxy}
  This is so that we
  * don't need to re-build the QueryProxy objects
  * also because the QueryProxy object caches it's results
  * so we don't need to query again
  * so that we can cache results from association calls or eager loading

  .. hidden-code-block:: ruby

     def association_proxy_cache
       @association_proxy_cache ||= {}
     end



.. _`Neo4j/ActiveNode#association_proxy_cache_fetch`:

**#association_proxy_cache_fetch**
  

  .. hidden-code-block:: ruby

     def association_proxy_cache_fetch(key)
       association_proxy_cache.fetch(key) do
         value = yield
         association_proxy_cache[key] = value
       end
     end



.. _`Neo4j/ActiveNode#association_query_proxy`:

**#association_query_proxy**
  

  .. hidden-code-block:: ruby

     def association_query_proxy(name, options = {})
       self.class.send(:association_query_proxy, name, {start_object: self}.merge!(options))
     end



.. _`Neo4j/ActiveNode#cache_key`:

**#cache_key**
  

  .. hidden-code-block:: ruby

     def cache_key
       if self.new_record?
         "#{model_cache_key}/new"
       elsif self.respond_to?(:updated_at) && !self.updated_at.blank?
         "#{model_cache_key}/#{neo_id}-#{self.updated_at.utc.to_s(:number)}"
       else
         "#{model_cache_key}/#{neo_id}"
       end
     end



.. _`Neo4j/ActiveNode#called_by`:

**#called_by**
  Returns the value of attribute called_by

  .. hidden-code-block:: ruby

     def called_by
       @called_by
     end



.. _`Neo4j/ActiveNode#called_by=`:

**#called_by=**
  Sets the attribute called_by

  .. hidden-code-block:: ruby

     def called_by=(value)
       @called_by = value
     end



.. _`Neo4j/ActiveNode#declared_property_manager`:

**#declared_property_manager**
  

  .. hidden-code-block:: ruby

     def declared_property_manager
       self.class.declared_property_manager
     end



.. _`Neo4j/ActiveNode#default_properties`:

**#default_properties**
  

  .. hidden-code-block:: ruby

     def default_properties
       @default_properties ||= Hash.new(nil)
       # keys = self.class.default_properties.keys
       # _persisted_obj.props.reject{|key| !keys.include?(key)}
     end



.. _`Neo4j/ActiveNode#default_properties=`:

**#default_properties=**
  

  .. hidden-code-block:: ruby

     def default_properties=(properties)
       default_property_keys = self.class.default_properties_keys
       @default_properties = properties.select { |key| default_property_keys.include?(key) }
     end



.. _`Neo4j/ActiveNode#default_property`:

**#default_property**
  

  .. hidden-code-block:: ruby

     def default_property(key)
       default_properties[key.to_sym]
     end



.. _`Neo4j/ActiveNode#dependent_children`:

**#dependent_children**
  

  .. hidden-code-block:: ruby

     def dependent_children
       @dependent_children ||= []
     end



.. _`Neo4j/ActiveNode#destroy`:

**#destroy**
  :nodoc:

  .. hidden-code-block:: ruby

     def destroy #:nodoc:
       tx = Neo4j::Transaction.new
       run_callbacks(:destroy) { super }
     rescue
       @_deleted = false
       @attributes = @attributes.dup
       tx.mark_failed
       raise
     ensure
       tx.close if tx
     end



.. _`Neo4j/ActiveNode#destroyed?`:

**#destroyed?**
  Returns +true+ if the object was destroyed.

  .. hidden-code-block:: ruby

     def destroyed?
       !!@_deleted
     end



.. _`Neo4j/ActiveNode#eql?`:

**#eql?**
  

  .. hidden-code-block:: ruby

     def ==(other)
       other.class == self.class && other.id == id
     end



.. _`Neo4j/ActiveNode#exist?`:

**#exist?**
  

  .. hidden-code-block:: ruby

     def exist?
       _persisted_obj && _persisted_obj.exist?
     end



.. _`Neo4j/ActiveNode#freeze`:

**#freeze**
  

  .. hidden-code-block:: ruby

     def freeze
       @attributes.freeze
       self
     end



.. _`Neo4j/ActiveNode#frozen?`:

**#frozen?**
  

  .. hidden-code-block:: ruby

     def frozen?
       @attributes.frozen?
     end



.. _`Neo4j/ActiveNode#hash`:

**#hash**
  

  .. hidden-code-block:: ruby

     def hash
       id.hash
     end



.. _`Neo4j/ActiveNode#id`:

**#id**
  

  .. hidden-code-block:: ruby

     def id
       id = neo_id
       id.is_a?(Integer) ? id : nil
     end



.. _`Neo4j/ActiveNode#init_on_load`:

**#init_on_load**
  called when loading the node from the database

  .. hidden-code-block:: ruby

     def init_on_load(persisted_node, properties)
       self.class.extract_association_attributes!(properties)
       @_persisted_obj = persisted_node
       changed_attributes && changed_attributes.clear
       @attributes = convert_and_assign_attributes(properties)
     end



.. _`Neo4j/ActiveNode#initialize`:

**#initialize**
  

  .. hidden-code-block:: ruby

     def initialize(attributes = {}, options = {})
       super(attributes, options)
       @attributes ||= self.class.attributes_nil_hash.dup
       send_props(@relationship_props) if _persisted_obj && !@relationship_props.nil?
     end



.. _`Neo4j/ActiveNode#inspect`:

**#inspect**
  

  .. hidden-code-block:: ruby

     def inspect
       id_property_name = self.class.id_property_name.to_s
       attribute_pairs = attributes.except(id_property_name).sort.map { |key, value| "#{key}: #{value.inspect}" }
       attribute_pairs.unshift("#{id_property_name}: #{self.send(id_property_name).inspect}")
       attribute_descriptions = attribute_pairs.join(', ')
       separator = ' ' unless attribute_descriptions.empty?
       "#<#{self.class.name}#{separator}#{attribute_descriptions}>"
     end



.. _`Neo4j/ActiveNode#labels`:

**#labels**
  

  .. hidden-code-block:: ruby

     def labels
       @_persisted_obj.labels
     end



.. _`Neo4j/ActiveNode#neo4j_obj`:

**#neo4j_obj**
  

  .. hidden-code-block:: ruby

     def neo4j_obj
       _persisted_obj || fail('Tried to access native neo4j object on a non persisted object')
     end



.. _`Neo4j/ActiveNode#neo_id`:

**#neo_id**
  

  .. hidden-code-block:: ruby

     def neo_id
       _persisted_obj ? _persisted_obj.neo_id : nil
     end



.. _`Neo4j/ActiveNode#new?`:

**#new?**
  Returns +true+ if the record hasn't been saved to Neo4j yet.

  .. hidden-code-block:: ruby

     def new_record?
       !_persisted_obj
     end



.. _`Neo4j/ActiveNode#new_record?`:

**#new_record?**
  Returns +true+ if the record hasn't been saved to Neo4j yet.

  .. hidden-code-block:: ruby

     def new_record?
       !_persisted_obj
     end



.. _`Neo4j/ActiveNode#pending_associations`:

**#pending_associations**
  

  .. hidden-code-block:: ruby

     def pending_associations
       @pending_associations ||= {}
     end



.. _`Neo4j/ActiveNode#pending_associations?`:

**#pending_associations?**
  

  .. hidden-code-block:: ruby

     def pending_associations?
       !@pending_associations.blank?
     end



.. _`Neo4j/ActiveNode#persisted?`:

**#persisted?**
  Returns +true+ if the record is persisted, i.e. it's not a new record and it was not destroyed

  .. hidden-code-block:: ruby

     def persisted?
       !new_record? && !destroyed?
     end



.. _`Neo4j/ActiveNode#props`:

**#props**
  

  .. hidden-code-block:: ruby

     def props
       attributes.reject { |_, v| v.nil? }.symbolize_keys
     end



.. _`Neo4j/ActiveNode#query_as`:

**#query_as**
  Returns a Query object with the current node matched the specified variable name

  .. hidden-code-block:: ruby

     def query_as(node_var)
       self.class.query_as(node_var, false).where("ID(#{node_var})" => self.neo_id)
     end



.. _`Neo4j/ActiveNode#read_attribute`:

**#read_attribute**
  Returning nil when we get ActiveAttr::UnknownAttributeError from ActiveAttr

  .. hidden-code-block:: ruby

     def read_attribute(name)
       super(name)
     rescue ActiveAttr::UnknownAttributeError
       nil
     end



.. _`Neo4j/ActiveNode#read_attribute_for_validation`:

**#read_attribute_for_validation**
  Implements the ActiveModel::Validation hook method.

  .. hidden-code-block:: ruby

     def read_attribute_for_validation(key)
       respond_to?(key) ? send(key) : self[key]
     end



.. _`Neo4j/ActiveNode#reload`:

**#reload**
  

  .. hidden-code-block:: ruby

     def reload
       return self if new_record?
       association_proxy_cache.clear
       changed_attributes && changed_attributes.clear
       unless reload_from_database
         @_deleted = true
         freeze
       end
       self
     end



.. _`Neo4j/ActiveNode#reload_from_database`:

**#reload_from_database**
  

  .. hidden-code-block:: ruby

     def reload_from_database
       # TODO: - Neo4j::IdentityMap.remove_node_by_id(neo_id)
       if reloaded = self.class.load_entity(neo_id)
         send(:attributes=, reloaded.attributes)
       end
       reloaded
     end



.. _`Neo4j/ActiveNode#remove_label`:

**#remove_label**
  Removes one or more labels
  Be careful, don't remove the label representing the Ruby class.

  .. hidden-code-block:: ruby

     def remove_label(*label)
       @_persisted_obj.remove_label(*label)
     end



.. _`Neo4j/ActiveNode#save`:

**#save**
  The validation process on save can be skipped by passing false. The regular Model#save method is
  replaced with this when the validations module is mixed in, which it is by default.

  .. hidden-code-block:: ruby

     def save(options = {})
       result = perform_validations(options) ? super : false
       if !result
         Neo4j::Transaction.current.failure if Neo4j::Transaction.current
       end
       result
     end



.. _`Neo4j/ActiveNode#save!`:

**#save!**
  Persist the object to the database.  Validations and Callbacks are included
  by default but validation can be disabled by passing :validate => false
  to #save!  Creates a new transaction.

  .. hidden-code-block:: ruby

     def save!(*args)
       fail RecordInvalidError, self unless save(*args)
     end



.. _`Neo4j/ActiveNode#send_props`:

**#send_props**
  

  .. hidden-code-block:: ruby

     def send_props(hash)
       hash.each { |key, value| self.send("#{key}=", value) }
     end



.. _`Neo4j/ActiveNode#serializable_hash`:

**#serializable_hash**
  

  .. hidden-code-block:: ruby

     def serializable_hash(*args)
       super.merge(id: id)
     end



.. _`Neo4j/ActiveNode#serialized_properties`:

**#serialized_properties**
  

  .. hidden-code-block:: ruby

     def serialized_properties
       self.class.serialized_properties
     end



.. _`Neo4j/ActiveNode#to_key`:

**#to_key**
  Returns an Enumerable of all (primary) key attributes
  or nil if model.persisted? is false

  .. hidden-code-block:: ruby

     def to_key
       _persisted_obj ? [id] : nil
     end



.. _`Neo4j/ActiveNode#touch`:

**#touch**
  :nodoc:

  .. hidden-code-block:: ruby

     def touch(*) #:nodoc:
       run_callbacks(:touch) { super }
     end



.. _`Neo4j/ActiveNode#update`:

**#update**
  Updates this resource with all the attributes from the passed-in Hash and requests that the record be saved.
  If saving fails because the resource is invalid then false will be returned.

  .. hidden-code-block:: ruby

     def update(attributes)
       self.attributes = process_attributes(attributes)
       save
     end



.. _`Neo4j/ActiveNode#update!`:

**#update!**
  Same as {#update_attributes}, but raises an exception if saving fails.

  .. hidden-code-block:: ruby

     def update!(attributes)
       self.attributes = process_attributes(attributes)
       save!
     end



.. _`Neo4j/ActiveNode#update_attribute`:

**#update_attribute**
  Convenience method to set attribute and #save at the same time

  .. hidden-code-block:: ruby

     def update_attribute(attribute, value)
       send("#{attribute}=", value)
       self.save
     end



.. _`Neo4j/ActiveNode#update_attribute!`:

**#update_attribute!**
  Convenience method to set attribute and #save! at the same time

  .. hidden-code-block:: ruby

     def update_attribute!(attribute, value)
       send("#{attribute}=", value)
       self.save!
     end



.. _`Neo4j/ActiveNode#update_attributes`:

**#update_attributes**
  Updates this resource with all the attributes from the passed-in Hash and requests that the record be saved.
  If saving fails because the resource is invalid then false will be returned.

  .. hidden-code-block:: ruby

     def update(attributes)
       self.attributes = process_attributes(attributes)
       save
     end



.. _`Neo4j/ActiveNode#update_attributes!`:

**#update_attributes!**
  Same as {#update_attributes}, but raises an exception if saving fails.

  .. hidden-code-block:: ruby

     def update!(attributes)
       self.attributes = process_attributes(attributes)
       save!
     end



.. _`Neo4j/ActiveNode#valid?`:

**#valid?**
  

  .. hidden-code-block:: ruby

     def valid?(context = nil)
       context ||= (new_record? ? :create : :update)
       super(context)
       errors.empty?
     end



.. _`Neo4j/ActiveNode#wrapper`:

**#wrapper**
  Implements the Neo4j::Node#wrapper and Neo4j::Relationship#wrapper method
  so that we don't have to care if the node is wrapped or not.

  .. hidden-code-block:: ruby

     def wrapper
       self
     end





