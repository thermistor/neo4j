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

            elsif arg.is_a?(Symbol) && self.respond_to?(:from_symbol)
              self.from_symbol arg

            elsif arg.is_a?(Integer) && self.respond_to?(:from_integer)
              self.from_integer arg

            elsif arg.is_a?(Hash) && self.respond_to?(:from_field_and_value)
              arg.map do |key, value|
                self.from_field_and_value key, value
              end

            elsif arg.is_a?(Array) && self.respond_to?(:from_string)
              arg.map do |value|
                self.from_args value
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
        def from_string(value)
          value
        end

        def from_field_and_value(field, value)
          "#{field}=`#{value}`"
        end

        def condition_string(conditions)
          conditions.map(&:value).join(' AND ')
        end
      end
    end


    class MatchCondition < Condition
      @keyword = 'MATCH'

      def value
        "(#{@value})"
      end

      class << self
        def from_string(value)
          value
        end

        def from_field_and_value(field, label)
          "#{field}:#{label}"
        end

        def condition_string(conditions)
          conditions.map(&:value).join(', ')
        end
      end
    end

    class OrderCondition < Condition
      @keyword = 'ORDER BY'

      class << self
        def from_string(value)
          if value.match('\.')
            value
          elsif [:id, :neo_id].include?(value.to_sym)
            'ID(n)'
          else
            "n.#{value}"
          end
        end

        def from_symbol(value)
          from_string(value.to_s)
        end

        def from_field_and_value(field, label)
          if [:id, :neo_id].include?(field.to_sym)
            "ID(n) #{label.upcase}"
          else
            "n.#{field} #{label.upcase}"
          end
        end

        def condition_string(conditions)
          conditions.map(&:value).join(', ')
        end
      end
    end

    class LimitCondition < Condition
      @keyword = 'LIMIT'

      class << self
        def from_string(value)
          value.to_i
        end

        def from_integer(value)
          value
        end

        def condition_string(conditions)
          conditions.last.value
        end
      end
    end

    class ReturnCondition < Condition
      @keyword = 'RETURN'

      class << self
        def from_string(value)
          value
        end

        def condition_string(conditions)
          conditions.map(&:value).join(', ')
        end
      end
    end


  end
end
