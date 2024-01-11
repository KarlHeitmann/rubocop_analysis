module RubocopAnalysis
  module Cops
    class Base
      attr_reader :severity, :message, :cop_name, :corrected, :correctable, :location

      def initialize(severity:, message:, cop_name:, corrected:, correctable:, location:)
        @severity = severity
        @message = message
        @cop_name = cop_name
        @corrected = corrected
        @correctable = correctable
        @location = location
      end

      def show(_indent = "")
        "TODO: Override me"
      end
    end
  end
end
