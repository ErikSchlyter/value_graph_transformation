require 'value_graph_transformation'

module ValueGraphTransformation
  describe Function do
    it "is a Vertex" do
      expect(Function.new).to be_a(Graph::Vertex)
    end
  end
end
