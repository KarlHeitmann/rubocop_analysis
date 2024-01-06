module RubocopAnalysis
  class Result
    attr_reader :nodes, :filtered_nodes

    def initialize(data)
      @summary = data["summary"]
      @metada = data["metadata"]
      @nodes = data["files"].map { Node.new(_1) }
      @filtered_nodes = @nodes.select { _1.offends? }
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
