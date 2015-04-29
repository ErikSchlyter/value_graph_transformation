require 'value_graph_transformation'

module ValueGraphTransformation
  describe Context do
    let!(:context) { Context.new }

    it "is a Graph" do
      expect(context).to be_a(Graph::Graph)
    end

    describe "#function" do

      it "should fail unless the type is a class that inherits from Function" do
        expect {
          context.function(String, [],[])
        }.to raise_error(RuntimeError, "'String' is not a function.")
      end

      it "should fail unless all input objects are Value objects" do
        expect {
          context.function(Function, ["foo"], [])
        }.to raise_error(RuntimeError, "input not Value objects")
      end

      it "should fail unless all output objects are Value objects" do
        expect {
          context.function(Function, [], ["foo"])
        }.to raise_error(RuntimeError, "output not Value objects")
      end

      it "should return a Function" do
        expect(context.function(Function, [], [])).to be_a(Function)
      end

      it "should connect the input and output vertices" do
        in1 = context.value_for(nil)
        in2 = context.value_for(nil)
        out = context.value_for(nil)
        function = context.function(Function, [in1, in2], [out])

        expect(in1.targets.first.target).to eq(function)
        expect(in2.targets.first.target).to eq(function)
        expect(function.sources[0].source).to eq(in1)
        expect(function.sources[1].source).to eq(in2)

        expect(function.targets.first.target).to eq(out)
        expect(out.sources.first.source).to eq(function)
      end

      it "should add the function to the context's list of vertices" do
        function = context.function(Function, [], [])

        expect(context.vertices).to include(function)
      end
    end

    describe "#value_for" do

      it "should return a Value object" do
        expect(context.value_for(nil)).to be_a(Value)
        expect(context.value_for("foo")).to be_a(Value)
        expect(context.value_for(12)).to be_a(Value)
      end

      it "should return the same Value if identifier has been given earlier" do
        a = context.value_for("foo")
        b = context.value_for("foo")

        expect(a).to eq(b)
      end

      it "should always create new Value objects if nil is given as identifier" do
        a = context.value_for(nil)
        b = context.value_for(nil)

        expect(a).not_to eq(b)
      end
    end

  end
end
