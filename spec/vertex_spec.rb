require 'value_graph_transformation'

module ValueGraphTransformation::Graph

  describe Vertex do
    let!(:graph) { Graph.new }
    let(:a) { graph.add }
    let(:b) { graph.add }

    describe "#source_vertices" do
      it "returns a list of the source vertices" do
        graph.connect(a, b)
        expect(a.source_vertices).to be_empty
        expect(b.source_vertices).to match([a])
      end
    end

    describe "#target_vertices" do
      it "returns a list of the target vertices" do
        graph.connect(a, b)
        expect(a.target_vertices).to match([b])
        expect(b.target_vertices).to be_empty
      end
    end
  end

end
