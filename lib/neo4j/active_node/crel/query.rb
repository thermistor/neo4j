require 'neo4j/active_node/crel/conditions'

module Neo4j::ActiveNode
  module Crel
    class Query
      include Neo4j::ActiveNode::Conditions

      include Enumerable

      def each
        Neo4j::Label.cypher_query(self.to_cypher).each do |node|
          yield node
        end
      end

      def initialize(label)
        @conditions = [MatchCondition.new("n:#{label}"), ReturnCondition.new('n')]
      end

      def match(*args)
        build_deeper_query(MatchCondition, *args)
      end

      def where(*args)
        build_deeper_query(WhereCondition, *args)
      end

      def order(*args)
        build_deeper_query(OrderCondition, *args)
      end

      def limit(*args)
        build_deeper_query(LimitCondition, *args)
      end

      def return(*args)
        build_deeper_query(ReturnCondition, *args)
      end

      def all
        self.to_a
      end

      def first(count = nil)
        self.order(:id).take(count)
      end

      def last(count = nil)
        self.order(id: :desc).take(count)
      end

      def take(count = nil)
        result = self.limit(count || 1).to_a

        count ? result.take(count) : result.first
      end

      def to_cypher
        conditions_by_class = @conditions.group_by(&:class)

        [MatchCondition, WhereCondition, ReturnCondition, OrderCondition, LimitCondition].map do |condition_class|
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
    end
  end
end

