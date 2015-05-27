require 'open3'

module ValueGraphTransformation

  # Compiles Context with Value and Function objects into dot code.
  class DotCompiler

    # A selection of vertices with the given color and text caption.
    Selection = Struct.new(:vertices, :text, :color)

    # @return [String] the default background color of Value nodes
    DEFAULT_VALUE_COLOR = "white"

    def initialize(context)
      @context = context
      @selections = []
    end

    # Set a background color with caption to a specific set of vertices.
    #
    # @param vertices [Array<Vertex>] the vertices to select.
    # @param text [String] the caption for the set.
    # @param color [String] the color string for the selection.
    # @return [Selection] the selection.
    def select(vertices, text, color)
      @selections << Selection.new(vertices, text, color)
    end

    # @return [String] the Context compiled into an SVG element
    # @raise [Error] if GraphViz is not installed on host.
    def to_svg
      DotCompiler.to_svg(to_dot)
    end

    # @param dot [String] the string in dot format to compile.
    # @return [String] the given string compiled into an SVG element.
    # @raise [Error] if GraphViz is not installed on host.
    def self.to_svg(dot)
      svg = nil
      fail_msg = nil
      begin
        Open3.popen3("dot -Tsvg") { |stdin, stdout, stderr, wait_thr|
          stdin.print(dot)
          stdin.close
          svg = stdout.read
          fail_msg = stderr.read
          exit_status = wait_thr.value # Process::Status object returned.
        }
      rescue => err
        raise "Could not execute dot, perhaps GraphViz is not installed?"
      end

      raise fail_msg unless fail_msg == ""

      # crop the header
      svg.sub!(/.*\n/, '') until svg.start_with?("<svg ")

      return svg
    end

    # @return [String] the Context compiled into dot code
    def to_dot
      ids = vertex_ids
      colors = color_map

      nodes = @context.vertices.collect{|vertex|
        properties = node_properties(vertex)
        properties['fillcolor'] = colors[vertex]
        "\t#{ids[vertex]} [#{propertify(properties)}];"
      }

      edges = @context.edges.collect{|edge|
        "\t#{ids[edge.source]}->#{ids[edge.target]};"
      }

      header = "\t#{caption}#{propertify(graph_properties)};\n"

      "digraph {\n#{header}#{(nodes+edges).join("\n")}\n}"
    end

    # @return [Hash<Vertex,String>] a mapping between each vertex and its dot id.
    def vertex_ids
      ids = {}
      @context.vertices.each_with_index{|vertex, index|
        ids[vertex] = "node#{index}"
      }
      ids
    end

    # @return [Hash<Vertex,String>] a mapping between each vertex in its dot color string.
    def color_map
      colors = Hash.new
      selected = selection_colors

      @context.vertices.each{|vertex|
        colors[vertex] = (selected[vertex].empty?) ? DEFAULT_VALUE_COLOR
                                                   : selected[vertex].join(':')
      }
      colors
    end

    # @return [Hash<Vertex,Array<String>>] a mapping between each vertex contained within a
    #                                      selection and its colors
    def selection_colors
      colors = Hash.new{|hash,key| hash[key] = [] }

      @selections.each{|selection|
        selection.vertices.each{|vertex|
          colors[vertex] << selection.color
        }
      }

      colors
    end

    # @param map [Hash]
    # return [String] the keys/values of the hash converted to dot property format: i.e.:
    #                 'property1="foo" property2="bar"'
    def propertify(map)
      map.collect{|property,value| "#{property}=\"#{value}\""}.join(' ')
    end

    # @param vertex [Vertex]
    # @return [Hash<String,String>] a hash of the dot properties of the vertex.
    def node_properties(vertex)
      case vertex
      when Value
        {
          'label' => vertex.identifiers.join(','),
          'shape' => (vertex.identifiers.empty?) ? 'circle' : 'oval',
          'style' => 'filled',
          'gradientangle' => 45,
          'width' => 0.3,
          'height' => 0.3
        }
      when Function
        {
          'label' => vertex.symbol,
          'shape' => 'square',
          'style' => 'filled',
          'width' => 0.3,
          'height' => 0.3
        }
      else
        fail
      end
    end


    # @return [Hash<String,String>] a hash of the properties of the digraph element.
    def graph_properties
      {
        'rankdir' => 'LR',
        'bgcolor' => '#FFFFFF00'
      }
    end

    # @return [String] the labels for the color descriptions.
    def caption
      return "" if @selections.empty?

      labels = @selections.collect{|selection|
        "<tr><td align=\"left\" bgcolor=\"#{selection.color}\">#{selection.text}</td></tr>"
      }

      "label=<<table border=\"0\">#{labels.join}</table>>"
    end

  end
end
