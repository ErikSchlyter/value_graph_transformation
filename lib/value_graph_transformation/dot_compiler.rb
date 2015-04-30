module ValueGraphTransformation

  # Compiles Context with Value and Function objects into dot code.
  class DotCompiler

    # @return [String] the default background color of Value nodes
    DEFAULT_VALUE_COLOR = "white"

    def initialize(context)
      @context = context

      @vertex_id = {}
      @vertex_colors = {}
      context.vertices.each_with_index{|vertex, index|
        @vertex_id[vertex] = "#{index}"
        @vertex_colors[vertex] = []
      }

      @graph_labels = []
    end

    # Set a background color with caption to a specific set of vertices.
    #
    # @param vertices [Array<Vertex>] the vertices to select.
    # @param text [String] the caption for the set.
    # @param color [String] the color string for the selection.
    # @return [DotCompiler] self.
    def select(vertices, text, color)
      vertices.each{|vertex| @vertex_colors[vertex] << color }
      @graph_labels <<
        "<tr><td align=\"left\" bgcolor=\"#{color}\">#{text} </td></tr>"

      self
    end

    # @return [String] the dot code
    def to_s
      nodes = @vertex_id.collect{|vertex,id|
        "\t#{id} #{vertex_attributes(vertex)};"
      }

      edges = @context.edges.collect{|edge|
        "\t#{@vertex_id[edge.source]}->#{@vertex_id[edge.target]};"
      }

      "digraph {#{caption}#{graph_attributes}\n#{(nodes+edges).join("\n")}\n}"
    end

    # @return [String] the label for the color descriptions.
    def caption
      return "" if @graph_labels.empty?
      "label=<<table border=\"0\">#{@graph_labels.join}</table>>"
    end

    # @param vertex [Vertex]
    # @return [String] the attributes for a specific vertex.
    def vertex_attributes(vertex)
      "[#{propertify(properties(vertex).merge(color_property(vertex)))}]"
    end

    # @param vertex [Vertex]
    # @return [Hash<String,String>] a hash of the properties of a Vertex.
    def properties(vertex)
      case vertex
      when Value
        return value_properties(vertex)
      when Function
        return function_properties(vertex)
      else
        return {}
      end
    end


    # @return [String] the attributes for the graph.
    def graph_attributes
      propertify(graph_properties)
    end

    # @return [Hash<String,String>] a hash of the properties of the graph.
    def graph_properties
      {
        'rankdir' => 'LR',
      }
    end

    # @param function [Vertex]
    # @return [Hash<String,String>] a hash of the properties of the function vertex
    def function_properties(function)
      {
        'label' => function.symbol,
        'shape' => 'square',
        'style' => 'filled',
        'width' => 0.3,
        'height' => 0.3
      }
    end

    # @param value [Vertex]
    # @return [Hash<String,String>] a hash of the properties of the value vertex
    def value_properties(value)
      {
        'label' => value.identifiers.join(','),
        'shape' => (value.identifiers.empty?) ? 'circle' : 'oval',
        'style' => 'filled',
        'gradientangle' => 45,
        'width' => 0.3,
        'height' => 0.3
      }
    end

    # @param vertex [Vertex]
    # @return [Hash<String,String>] a hash of the color properties of the vertex.
    def color_property(vertex)
      colors = @vertex_colors[vertex].join(':')
      { 'fillcolor' => ((colors == '') ? DEFAULT_VALUE_COLOR : colors)  }
    end

    # @param map [Hash]
    # return [String] the keys/values converted to dot property format: i.e.:
    #                 'property1="foo" property2="bar"'
    def propertify(map)
      map.collect{|property,value| "#{property}=\"#{value}\""}.join(' ')
    end
  end
end
