
module ValueGraphTransformation

  # Basic arithmetic operations, like addition, subtraction, etc.
  module Arithmetic

    # Apply the block with arithmetic operations to the given context
    # @param context [Context] the context
    # @param arithmetic [Proc] the block to be invoked in the context of a
    #                          ArithmeticFunctionFactory.
    # @return [Context] the context in which the arithmetic operations were applied.
    def self.apply(context, &arithmetic)
      ArithmeticFunctionFactory.new(context).instance_eval &arithmetic
      context
    end

    # A factory for creating and adding basic arithmetic functions to a Context.
    class ArithmeticFunctionFactory
      def initialize(context)
        @context = context
      end

      # Creates function for addition.
      # @param term1 [Object] the first term.
      # @param term2 [Object] the second term.
      # @param result [Value,Object] the optional result identifier, will be created
      #                              if not given.
      # @return [Value] the function's resulting Value node.
      def add(term1, term2, result=nil)
        single_output_function(Add, [term1, term2], result)
      end

      # Creates a function for addition, with multiple terms.
      # @param terms [Array<Object>] an array of identifiers or Value objects.
      # @param result [Value,Object] the optional result identifier, will be created
      #                              if not given.
      # @return [Value] the function's resulting Value node.
      def sum(terms, result=nil)
        single_output_function(Add, terms, result)
      end

      # Creates function for subtraction.
      # @param term1 [Object] the first term.
      # @param term2 [Object] the second term.
      # @param result [Value,Object] the optional result identifier, will be created
      #                              if not given.
      # @return [Value] the function's resulting Value node.
      def sub(term1, term2, result=nil)
        single_output_function(Sub, [term1, term2], result)
      end

      # Creates function for multiplication.
      # @param factor1 [Object] the first factor.
      # @param factor2 [Object] the second factor.
      # @param result [Value,Object] the optional result identifier, will be created
      #                              if not given.
      # @return [Value] the function's resulting Value node.
      def mul(factor1, factor2, result=nil)
        single_output_function(Mul, [factor1, factor2], result)
      end

      # Creates function for division.
      # @param numerator [Object]
      # @param denominator [Object]
      # @param result [Value,Object] the optional result identifier, will be created
      #                              if not given.
      # @return [Value] the function's resulting Value node.
      def div(numerator, denominator, result=nil)
        single_output_function(Div, [numerator, denominator], result)
      end

      # Creates a Function with the given type and input identifiers, and returns the
      # result Value so that several invocations can be nested together.
      #
      # @param type [Class] the Function class to instantiate.
      # @param input [Array<Object>] an array of identifiers or Value objects.
      # @param output [Object] optional identifier or Value, will be created if not
      #                        given.
      # @return [Value] the result Value.
      def single_output_function(type, input, output=nil)
        function = @context.function(type, values(input), values([output]))
        fail "#{type} not a single output function" unless function.targets.size == 1

        function.targets.first.target
      end

      # @param objs [Array<Object>] a collection of identifiers.
      # @return [Array<Value>] the collection of Value nodes for the given objects.
      def values(objs)
        objs.collect{|obj| obj.is_a?(Value) ? obj : @context.value_for(obj)}
      end
    end

    # Addition
    class Add < Function
      # @return [String] the symbol that represents this function.
      def symbol
        "+"
      end
    end

    # Subtraction
    class Sub < Function
      # @return [String] the symbol that represents this function.
      def symbol
        "-"
      end
    end

    # Multiplication
    class Mul < Function
      # @return [String] the symbol that represents this function.
      def symbol
        "&times;"
      end
    end

    # Division
    class Div < Function
      # @return [String] the symbol that represents this function.
      def symbol
        "&#247;"
      end
    end

  end
end
