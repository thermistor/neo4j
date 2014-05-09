module Neo4j::ActiveNode
  module Conditions

    class Condition
      attr_reader :value

      def initialize(value)
        @value = value
      end

      class << self
        def from_args(args)
          args.map do |arg|
            if arg.is_a?(String) && self.respond_to?(:from_string)
              self.from_string arg

            elsif arg.is_a?(Hash) && self.respond_to?(:from_hash)
              arg.map do |key, value|
                self.from_hash key, value
              end

            elsif arg.is_a?(Array) && self.respond_to?(:from_string)
              arg.map do |value|
                self.from_string value
              end

            else
              raise ArgumentError, "Invalid argument"
            end
          end.flatten.map {|value| self.new(value) }
        end

        def to_cypher(conditions)
          "#{@keyword} #{condition_string(conditions)}"
        end
      end
    end

    class WhereCondition < Condition
      @keyword = 'WHERE'

      class << self
        def from_string(string)
          string
        end

        def from_hash(field, value)
          "#{field}=`#{value}`"
        end

        def condition_string(conditions)
          conditions.map(&:value).join(' AND ')
        end
      end
    end


    class MatchCondition < Condition
      @keyword = 'MATCH'

      class << self
        def from_string(string)
          string
        end

        def from_hash(variable, label)
          "#{variable}:#{label}"
        end

        def condition_string(conditions)
          conditions.map(&:value).join(', ')
        end
      end
    end

  end
end
