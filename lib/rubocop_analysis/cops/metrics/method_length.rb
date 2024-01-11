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

        def show(indent = "")
          # TODO: Show line number next to the file where the offense begin, in vim syntax
          <<~SHOW
            #{indent}#{cop_name}
            #{indent}#{severity}
            #{indent}#{message}
            #{indent} ::: ::: :::
          SHOW
        end
      end
    end
  end
end
