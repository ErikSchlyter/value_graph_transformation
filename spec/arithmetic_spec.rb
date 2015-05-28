require 'rspec/illustrate'
require 'value_graph_transformation'
require 'spec_helper'

module ValueGraphTransformation
  module Arithmetic

    describe ArithmeticFunctionFactory do
      include IllustrationCompiler

      shared_examples "a function factory" do

        let!(:context) { Context.new }
        let!(:factory) { ArithmeticFunctionFactory.new(context) }
        it "creates a function and returns the result node" do
          result = function

          dot_compiler = DotCompiler.new(context)
          dot_compiler.select( [result.sources[0].source], "the function node", "#00FFC0")
          dot_compiler.select( [result], "the result node", "#00C0FF")

          expect(result).to be_a(Value)

          illustrate dot_compiler
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

    describe ValueGraphTransformation::Arithmetic do
      include IllustrationCompiler

      describe ".apply" do
        example "It returns a Context" do
          expect(Arithmetic.apply {} ).to be_a(Context)
        end
        example "The block is executed within the scope of ArithmeticFunctionFactory." do
          prc = lambda {
            Arithmetic.apply {
              add(mul(7, 'x'), sub('a', div('42', 'y')), sum(['z', 47, 'u']))
            }
          }

          context = prc.call

          illustrate prc
          illustrate context
          expect(context).to be_a(Context)
        end

        example "It applies the block operations to the given context" do
          prc = lambda {
            context = Arithmetic.apply {
              add(1337, 42, 'z')
            }

            Arithmetic.apply(context) {
              mul('x', 'y', 'z')
            }
          }

          context = prc.call

          illustrate prc
          illustrate context
          expect(context).to be_a(Context)
          expect(context.vertices.size).to eq(7)
        end
      end
    end
  end
end

