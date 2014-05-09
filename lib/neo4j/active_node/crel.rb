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

      private

      def new_query(method, *args)
        Query.new(self.to_s).send(method, *args)
      end
    end
  end

end

