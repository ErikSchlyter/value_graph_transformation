require 'rspec/illustrate'
require 'value_graph_transformation'

module ValueGraphTransformation
  module Arithmetic

    describe ArithmeticFunctionFactory do
      shared_examples "a function factory" do
        let!(:context) { Context.new }
        let!(:factory) { ArithmeticFunctionFactory.new(context) }
        it "creates a function and returns the result node" do
          result = function

          illustrate context.to_dot([result])
          expect(result).to be_a(Value)
        end
      end

      describe "#add" do
        let(:function) { factory.add(1337, 42) }
        it_behaves_like "a function factory"
      end

      describe "#sub" do
        let(:function) { factory.sub(1337, 42) }
        it_behaves_like "a function factory"
      end

      describe "#mul" do
        let(:function) { factory.mul(13, 'a') }
        it_behaves_like "a function factory"
      end

      describe "#div" do
        let(:function) { factory.div('n', 'd') }
        it_behaves_like "a function factory"
      end
    end

    describe "#apply" do
      it "should apply arithmetic operations in the given block to the context" do
        context = Context.new
        result = Arithmetic.apply(context) {
          add(mul(7, 'x'), sub('a', div('42', 'y')), sum(['z', 47, 'u']))
        }

        illustrate context.to_dot
        expect(result).to eq(context)
      end
    end
  end
end

