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

    # @param source [Vertex]
    # @return [Boolean] true, iff the given vertex matches any of the node's sources.
    def contain_source?(source)
      sources.any?{|node| node.source == source }
    end

  end
end
