module Neo4j
  module ActiveNode
    module Query
      module QueryProxyEagerLoading
        def initialize(model, association = nil, options = {})
          @associations_spec = []

          super
        end

        def each(node = true, rel = nil, &block)
          if @associations_spec.size > 0
            return_object_clause = '[' + @associations_spec.map { |n| "collect(#{n})" }.join(',') + ']'
            query_from_association_spec.pluck(identity, return_object_clause).map do |record, eager_data|
              eager_data.each_with_index do |eager_records, index|
                record.association_proxy(@associations_spec[index]).cache_result(eager_records)
              end

              block.call(record)
            end
          else
            super
          end
        end

        def with_associations(*spec)
          new_link.tap do |new_query_proxy|
            new_spec = new_query_proxy.instance_variable_get('@associations_spec') + spec
            new_query_proxy.instance_variable_set('@associations_spec', new_spec)
          end
        end

        private

        def query_from_association_spec
          @associations_spec.inject(query_as(identity).return(identity)) do |query, association_name|
            association = model.associations[association_name]

            query.optional_match("#{identity}#{association.arrow_cypher}#{association_name}")
              .where(association.target_where_clause)
          end
        end
      end
    end
  end
end
