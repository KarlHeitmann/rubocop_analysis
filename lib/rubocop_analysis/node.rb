module RubocopAnalysis
  class Node
    attr_reader :path, :offenses
    def initialize(data)
      @path = data["path"]
      @offenses = data["offenses"].map { RubocopAnalysis::Offense.offended_cop(_1) }
    end

    def offends?
      @offenses.any?
    end

    def as_hash
      { path: @path, offenses: @offenses }
    end
  end
end
