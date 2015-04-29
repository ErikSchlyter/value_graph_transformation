
# A directed Graph
module ValueGraphTransformation::Graph

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

    # Adds a vertex to the graph.
    # @param vertex [Vertex] the vertex to add
    # @return [Vertex] the newly created Vertex.
    def add(vertex=Vertex.new)
      @vertices << vertex
      vertex
    end

    # Creates an edge between two vertices.
    #
    # @param source [Vertex] the source vertex
    # @param target [Vertex] the target vertex
    # @return [Edge] the newly created Edge between the two vertices.
    def connect(source, target)
      fail "'#{source.to_s}' not part of the graph" unless vertices.include?(source)
      fail "'#{target.to_s}' not part of the graph" unless vertices.include?(target)

      edge = Edge.new(source, target)
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

    # @return [String] the graph in dot code.
    def to_dot
      ids = {}
      @vertices.each_with_index{|vertex, index| ids[vertex] = "#{index}" }
      nodes = ids.values.collect{|id| "\t#{id};"}
      edges = @edges.collect{|edge| "\t#{ids[edge.source]}->#{ids[edge.target]};" }
      "digraph {\n#{(nodes+edges).join("\n")}\n}"
    end
  end
end
