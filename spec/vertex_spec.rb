require 'value_graph_transformation'

module ValueGraphTransformation::Graph

  describe Vertex do
    let!(:graph) { Graph.new }
    let(:a) { graph.add }
    let(:b) { graph.add }

    describe "#contain_source?" do
      it "Returns true if the given node matches any of the node's sources" do
        graph.connect(a, b)

        expect(b.contain_source?(a)).to be true
        expect(a.contain_source?(b)).to be false
      end
    end

  end

end
