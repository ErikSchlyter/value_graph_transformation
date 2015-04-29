
module ValueGraphTransformation

  # An abstract base class that represents a function, where inputs and outputs are
  # connected to Value objects.
  class Function < Graph::Vertex

    # @return [String] the dot code for the properties of this Vertex.
    def to_dot(selected=false)
      fill_color = selected ? "fillcolor=\"cyan\"" : ""
      "[label=\"#{symbol}\" #{fill_color} shape=\"square\"]"
    end

    # @return [String] the symbol that represents this function.
    def symbol
      self.class.name.split('::').last
    end
  end

end

