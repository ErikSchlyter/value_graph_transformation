module ValueGraphTransformation

  # A directed Graph
  class Graph
    # @return [Array<Vertex>]
    attr_reader :vertices

    # @return [Array<Edge>]
    attr_reader :edges

    def initialize
      @vertices = []
      @edges = []
    end

    # Creates a new vertex with the optional meta object associated to it, and adds
    # it to the graph.
    #
    # @param meta [Object] the meta object to associate with the new vertex.
    # @return [Vertex] the newly created Vertex.
    def add(meta=nil)
      vertex = Vertex.new(meta)
      @vertices << vertex
      vertex
    end

    # Creates an edge between two vertices and associates an optional meta object to
    # it.
    #
    # @param source [Vertex] the source vertex
    # @param target [Vertex] the target vertex
    # @param meta [Object] the meta object associated with this edge.
    # @return [Edge] the newly created Edge between the two vertices.
    def connect(source, target, meta=nil)
      fail "'#{source.to_s}' not part of the graph" unless vertices.include?(source)
      fail "'#{target.to_s}' not part of the graph" unless vertices.include?(target)

      edge = Edge.new(source, target, meta)
      source.targets << edge
      target.sources << edge
      @edges << edge
      edge
    end

    # Removes the vertex from the graph and disconnects its edges.
    # @param vertex [Vertex] the vertex to remove.
    def delete(vertex)
      fail "'#{vertex.to_s}' not part of the graph" unless @vertices.delete(vertex)
      (vertex.targets + vertex.sources).each{|edge| disconnect(edge)}
    end

    # Disconnects and removes the edge from the graph.
    # @param edge [Edge] the edge to remove.
    def disconnect(edge)
      fail "'#{edge.to_s}' not part of the graph" unless @edges.delete(edge)
      edge.source.targets.delete(edge)
      edge.source = nil
      edge.target.sources.delete(edge)
      edge.target = nil
    end

  end
end
