require 'rspec/illustrate'
require 'value_graph_transformation'

module ValueGraphTransformation::Graph

  describe Graph do
    let!(:graph) { Graph.new }
    let(:a) { graph.add }
    let(:b) { graph.add }
    let(:c) { graph.add }


    describe "#add" do
      it "should return a vertex" do
        expect(graph.add).to be_a(Vertex)
      end

      it "should add the vertex to its list of vertices" do
        expect(graph.vertices).to match [graph.add]
      end
    end

    describe "#connect" do
      it "should return an edge" do
        expect(graph.connect(a, b)).to be_a(Edge)
      end

      it "should add the edge to its list of edges" do
        expect(graph.edges).to match [ graph.connect(a, b) ]
      end

      it "should add the edge on the source list of the target vertex" do
        edge = graph.connect(a, b)
        expect(b.sources).to match [edge]
      end

      it "should add the edge on the target list of the source vertex" do
        edge = graph.connect(a, b)
        expect(a.targets).to match [edge]
      end

      it "should fail if source not part of the graph" do
        expect {
          graph.connect("foo", b)
        }.to raise_error(RuntimeError, "'foo' not part of the graph")
      end

      it "should fail if target not part of the graph" do
        expect {
          graph.connect(a, "foo")
        }.to raise_error(RuntimeError, "'foo' not part of the graph")
      end
    end

    describe "#delete" do
      it "should remove the vertex from the graph" do

      end
    end

    describe "#disconnect" do
      let!(:a_b) { graph.connect(a, b) }
      let!(:b_c) { graph.connect(b, c) }

      it "should remove the edge from the graph" do
        graph.disconnect(b_c)

        expect(graph.edges).to match [a_b]
        expect(b.sources).to match [a_b]
      end

      it "should remove the edge from the source list of the target vertex" do
        graph.disconnect(b_c)
        expect(c.sources).to be_empty
      end

      it "should remove the edge from the target list of the source vertex" do
        graph.disconnect(b_c)
        expect(b.targets).to be_empty
      end
    end

    describe "#to_dot" do

      it "should return a String in valid dot format" do
        graph.connect(a, b)
        graph.connect(a, b)
        graph.connect(c, a)
        graph.connect(a, c)

        dot = graph.to_dot
        expect(dot).to be_a(String)

        illustrate dot
      end

    end

  end
end

