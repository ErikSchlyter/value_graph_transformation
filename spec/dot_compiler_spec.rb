require 'rspec/illustrate'
require 'value_graph_transformation'

module ValueGraphTransformation

  describe DotCompiler do

    let!(:context)  { Context.new }
    let!(:node1)    { context.value_for('a') }
    let!(:node2)    { context.value_for('b') }
    let!(:node3)    { context.value_for('c') }
    let!(:function) { context.function(Arithmetic::Add, [node1, node2], [node3]) }
    let!(:compiler) { DotCompiler.new(context) }

    describe "#to_svg" do
      example "It compiles the context into a String in svg format." do
        svg = compiler.to_svg
        illustrate svg, :html=>svg
        expect(svg).to be_a(String)
      end
    end

    describe "#to_dot" do
      example "It compiles the context into a String in dot format." do
        dot = compiler.to_dot
        illustrate dot
        expect(dot).to be_a(String)
      end
    end


    describe "#vertex_ids" do
      example "It returns a Hash" do
        expect(compiler.vertex_ids).to be_a(Hash)
      end

      example "Each vertex in the context is mapped to a unique id string" do
        hash = compiler.vertex_ids
        expect(hash.keys).to match(context.vertices)
        expect(hash.values).to all(be_a(String))
        expect(hash.values).to match(hash.values.uniq)
      end
    end


    describe "#color_map" do
      let(:hash) { compiler.color_map}
      example "it returns a Hash." do
        expect(hash).to be_a(Hash)
      end

      context "When there are no vertex selections" do
        example "each vertex in Context is mapped to default color string" do
          expect(hash.keys).to match(context.vertices)
        end
      end

      context "When some vertices are selected" do
        let!(:input) { [node1, node2] }

        before {
          compiler.select(input, "Input", "red")
        }

        example "the selected vertices are mapped to the given color string" do
          expect(hash[node1]).to eq("red")
          expect(hash[node2]).to eq("red")
        end

        context "When a vertex is selected more than once" do
          before {
            compiler.select([node1], "foo", "green")
            compiler.select([node1], "bar", "blue")
          }

          example "it is mapped to a string containing all colors separated by a colon" do
            expected = "red:green:blue"
            illustrate expected
            expect(hash[node1]).to eq(expected)
          end
        end
      end
    end

    describe "#selection_colors" do
      let(:hash) { compiler.selection_colors }

      context "When there are no vertex selections" do
        example "it returns an empty hash." do
          expect(hash).to be_a(Hash)
          expect(hash).to be_empty
        end
      end

      context "When some vertices are selected" do
        let!(:input) { [node1, node2] }
        before {
          compiler.select(input, "Input", "red")
        }

        example "the selected vertices should be keys in the hash." do
          expect(hash).to be_a(Hash)
          expect(hash.keys).to match(input)
        end

        example "each value is an Array containing the given color string." do
          expect(hash.values).to all(match( ["red"] ))
        end

        context "When a vertex is selected more than once" do
          before {
            compiler.select([node1], "foo", "green")
            compiler.select([node1], "bar", "blue")
          }

          example "the array should contain color strings from all its selections" do
            expect(hash[node1]).to match(["red", "green", "blue"])
          end

        end
      end
    end


    describe "#propertify" do
      example "It converts the given Hash to a string in dot property format" do
        hash = { "property1" => "foo", "property2" => "bar" }
        illustrate hash.inspect, :label=>"Given the hash:"

        expected = 'property1="foo" property2="bar"'
        illustrate expected, :label=>"The expected string:"

        actual = compiler.propertify(hash)
        illustrate actual.inspect, :show_when_passed=>false

        expect(actual).to eq(expected)
      end
    end

    describe "#node_properties" do
      example "returns a Hash with the properties of a vertex" do
        illustrate compiler.node_properties(node1).inspect,    :label=>"A value node"
        illustrate compiler.node_properties(function).inspect, :label=>"A function node"

        expect(compiler.node_properties(node1)).to be_a(Hash)
      end
    end

    describe "#graph_properties" do
      example "returns a Hash with the properties of the digraph element" do
        illustrate compiler.graph_properties.inspect
        expect(compiler.graph_properties).to be_a(Hash)
      end
    end

    describe "#caption" do
      context "When there are no vertex selections" do
        example "It returns an empty string" do
          expect(compiler.caption).to eq ""
        end
      end
    end
  end
end

