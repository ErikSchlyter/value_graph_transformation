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

    # @return [Array<Vertex>] the source vertices
    def source_vertices
      sources.collect{|edge| edge.source }
    end

    # @return [Array<Vertex>] the target vertices
    def target_vertices
      targets.collect{|edge| edge.target }
    end

  end
end
