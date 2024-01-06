# frozen_string_literal: true

module RubocopAnalysis
  class Node
    attr_reader :path, :offenses

    def initialize(data)
      @path = data["path"]
      @offenses = data["offenses"].map { RubocopAnalysis::Offense.offended_cop(_1) }
    end

    def offends?(klasses)
      if klasses.empty?
        @offenses.any?
      else
        # binding.pry if @offenses.any?
        @offenses.select { klasses.include? _1.class }.any?
      end
    end

    def as_hash
      { path: @path, offenses: @offenses }
    end
  end
end
