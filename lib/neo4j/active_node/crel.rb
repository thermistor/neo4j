require 'neo4j/active_node/crel/conditions'

module Neo4j::ActiveNode
  # A means of generating Cypher queries based on the Arel gem
  module Crel

    class Query
      include Neo4j::ActiveNode::Conditions

      def initialize(label)
        @conditions = [MatchCondition.new("n:#{label}")]
      end

      def match(*args)
        build_deeper_query(MatchCondition, *args)
      end

      def where(*args)
        build_deeper_query(WhereCondition, *args)
      end

      def all
      end

      def first
      end

      def to_cypher
        conditions_by_class = @conditions.group_by(&:class)

        [MatchCondition, WhereCondition].map do |condition_class|
          conditions = conditions_by_class[condition_class]

          condition_class.to_cypher(conditions) if conditions
        end.compact.join ' '
      end

      protected

      def add_conditions(conditions)
        @conditions += conditions
      end

      private

      def build_deeper_query(condition_class, *args)
        self.dup.tap do |new_query|
          new_query.add_conditions condition_class.from_args(args)
        end
      end

      def match_cypher
        if @matches.size > 0
          conditions = @matches.map do |value|
            "#{value}"
          end.join ', '

          "MATCH #{conditions}"
        end
      end

      def where_cypher
        if @wheres.size > 0
          conditions = @wheres.map do |key, value|
            "#{key}=`#{value}`"
          end.join ' AND '

          "WHERE #{conditions}"
        end
      end
    end

    extend ActiveSupport::Concern

    module ClassMethods
      def where(*args)
        new_query(:where)
      end

      def order(*args)
        new_query(:order)
      end

      def limit(*args)
        new_query(:limit)
      end

      private

      def new_query(method, *args)
        Query.new(self.to_s).send(method, *args)
      end
    end
  end

end

