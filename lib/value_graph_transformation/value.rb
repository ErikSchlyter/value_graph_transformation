
module ValueGraphTransformation

  # Represents a value, which can be identified with a fixed number or a
  # variable identifier.
  class Value < Graph::Vertex

    def initialize(identifier=nil)
      super()
      @identifiers = []
      @identifiers << identifier unless identifier.nil?
    end

    # @return [String] the dot code for the properties of this Vertex.
    def to_dot(selected=false)
      fill_color = selected ? "fillcolor=\"cyan\"" : ""
      label = @identifiers.join(',')
      if label == "" then
        return "[label=\"\" shape=\"circle\" #{fill_color}]"
      else
        return "[label=\"#{label}\" shape=\"oval\" #{fill_color}]"
      end

    end

  end

end
