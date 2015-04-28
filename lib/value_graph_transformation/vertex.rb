module ValueGraphTransformation

  # A vertex in the graph.
  class Vertex

    # @return [Array<Edge>]
    attr_reader :targets

    # @return [Array<Edge>]
    attr_reader :sources

    # @return [Object] the meta object associated with this vertex.
    attr_reader :meta

    # @param meta [Object] the meta object associated with this vertex.
    def initialize(meta=nil)
      @meta = meta
      @targets = []
      @sources = []
    end

  end
end
