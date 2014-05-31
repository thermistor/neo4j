module Neo4j::ActiveNode
  # A means of generating Cypher queries based on the Arel gem
  module Crel
    extend ActiveSupport::Concern

    module ClassMethods
      def where(*args)
        new_query(:where, *args)
      end

      def order(*args)
        new_query(:order, *args)
      end

      def limit(*args)
        new_query(:limit, *args)
      end

      def take(count = nil)
        new_query.take(count)
      end

      private

      def new_query(method = nil, *args)
        query = Query.new(self.to_s)

        method ? query.send(method, *args) : query
      end
    end
  end

end

