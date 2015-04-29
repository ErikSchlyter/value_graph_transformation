
module ValueGraphTransformation

  # Represents a value, which can be identified with a fixed number or a
  # variable identifier.
  class Value < Graph::Vertex

    # @return [Array<Object>] the identifiers of this value.
    attr_reader :identifiers

    def initialize(identifier=nil)
      super()
      @identifiers = []
      @identifiers << identifier unless identifier.nil?
    end

  end
end
