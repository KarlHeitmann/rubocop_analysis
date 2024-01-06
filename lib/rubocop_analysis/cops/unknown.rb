module RubocopAnalysis
  module Cops
    class Unknown < RubocopAnalysis::Cops::Base
      attr_reader :severity, :message, :cop_name, :corrected, :correctable, :location

      def initialize(data)
        super(**data.transform_keys { _1.to_sym rescue key })
      end
    end
  end
end
