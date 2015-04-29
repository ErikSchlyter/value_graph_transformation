module ValueGraphTransformation::Graph

  # A directed edge between two vertices.
  class Edge

    # @return [Vertex] the source vertex.
    attr_accessor :source

    # @return [Vertex] the target vertex.
    attr_accessor :target

    # @param source [Vertex] the source vertex
    # @param target [Vertex] the target vertex
    def initialize(source, target)
      fail "source '#{source.to_s}' is not a Vertex" unless source.is_a?(Vertex)
      fail "target '#{target.to_s}' is not a Vertex" unless target.is_a?(Vertex)
      @source = source
      @target = target
    end

  end
end

