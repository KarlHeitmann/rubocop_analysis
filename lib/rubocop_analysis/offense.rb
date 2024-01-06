# frozen_string_literal: true

module RubocopAnalysis
  class Offense
    def self.offended_cop(data)
      if data["cop_name"] == "Metrics/MethodLength"
        RubocopAnalysis::Cops::Metrics::MethodLength.new(data)
      else
        RubocopAnalysis::Cops::Unknown.new(data)
      end
    end
  end
end
