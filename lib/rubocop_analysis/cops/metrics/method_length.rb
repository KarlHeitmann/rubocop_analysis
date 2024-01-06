module RubocopAnalysis
  module Cops
    module Metrics
      class MethodLength < RubocopAnalysis::Cops::Base
        attr_reader :total_lines, :max_lines, :excess_lines

        def initialize(data)
          super(**data.transform_keys { _1.to_sym rescue key })

          @total_lines, @max_lines = message.split(". ")[-1][1...-1].split("/").map(&:to_i)
          @excess_lines = @total_lines - @max_lines
        end

        def compare
          # 0 - @excess_lines
          @excess_lines
        end
      end
    end
  end
end
