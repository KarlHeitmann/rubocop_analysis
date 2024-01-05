module Cops
  module Metrics
    class MethodLength
      attr_reader :severity, :message, :cop_name, :corrected, :correctable, :location, :total_lines, :max_lines, :excess_lines

      def initialize(offense)
        @severity = offense["severity"]
        @message = offense["message"]
        @cop_name = offense["cop_name"]
        @corrected = offense["corrected"]
        @correctable = offense["correctable"]
        @location = offense["location"]

        # @total_lines, @max_lines = message.split(". ")[-1][1...-1].split("/").map { _1.to_i }
        @total_lines, @max_lines = message.split(". ")[-1][1...-1].split("/").map(&:to_i)
        @excess_lines = @total_lines - @max_lines
        # binding.pry
        # total_lines, max_lines = message.split(". ")[-1].split()
      end

      def compare
        # 0 - @excess_lines
        @excess_lines
      end
    end
  end
end

