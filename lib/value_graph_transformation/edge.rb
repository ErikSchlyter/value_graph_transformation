module ValueGraphTransformation

  # A directed edge between two vertices.
  class Edge

    # @return [Vertex] the source vertex.
    attr_accessor :source

    # @return [Vertex] the target vertex.
    attr_accessor :target

    # @return [Object] the meta object associated with this edge.
    attr_accessor :meta

    # @param source [Vertex] the source vertex
    # @param target [Vertex] the target vertex
    # @param meta [Object] the meta object associated with this edge.
    def initialize(source, target, meta=nil)
      fail "source '#{source.to_s}' is not a Vertex" unless source.is_a?(Vertex)
      fail "target '#{target.to_s}' is not a Vertex" unless target.is_a?(Vertex)
      @source = source
      @target = target
      @meta = meta
    end

  end
end

