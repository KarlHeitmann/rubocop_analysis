module RubocopAnalysis
  class Result
    attr_reader :nodes

    def initialize(data)
      @summary = data["summary"]
      @metada = data["metadata"]
      @nodes = data["files"].map { Node.new(_1) }
    end

    def filtered_nodes(klasses)
      @nodes.select { _1.offends?(klasses) }
    end

    def header
      <<~HEADER
        ================================================================
        Parsed '#{@file_name}' file successfully
        --------------------------
        #{@summary}
        --------------------------
        #{@metadata}

      HEADER
    end
  end

  class Core
    def self.analyze(data)
      Result.new(data)
    end
  end
end
