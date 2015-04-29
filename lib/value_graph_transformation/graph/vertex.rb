module ValueGraphTransformation::Graph

  # A vertex in the graph.
  class Vertex

    # @return [Array<Edge>]
    attr_reader :targets

    # @return [Array<Edge>]
    attr_reader :sources

    def initialize()
      @targets = []
      @sources = []
    end

  end
end
