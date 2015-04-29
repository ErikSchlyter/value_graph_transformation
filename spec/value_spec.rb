require 'value_graph_transformation'

module ValueGraphTransformation
  describe Value do
    it "is a Vertex" do
      expect(Value.new).to be_a(Graph::Vertex)
    end
  end
end

