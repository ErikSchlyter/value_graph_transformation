module ValueGraphTransformation

  # A context consist of a set of functions, values and their relationships.
  class Context < Graph::Graph
    def initialize
      super
      @identifiers = {}
    end

    # @param type [Class] the Function class to instantiate.
    # @param input [Array<Value>] the input values.
    # @param output [Array<Value>] the output values.
    def function(type, input, output)
      fail "'#{type}' is not a function." unless type <= Function
      fail "input not Value objects" unless input.all?{|value| value.is_a?(Value)}
      fail "output not Value objects" unless output.all?{|value| value.is_a?(Value)}

      function = type.new
      add(function)
      input.each{|value| connect(value, function) }
      output.each{|value| connect(function, value) }
      function
    end

    # Creates a Value node, or returns the existing one if the given identifier is
    # already defined in this Context. If no identifier is given it will create a new
    # Value and return that.
    #
    # @param identifier [Object] the identifier.
    # @return [Value] the Value node for the identifier in this Context.
    def value_for(identifier=nil)
      value = @identifiers[identifier]
      if value.nil? then
        value = Value.new(identifier)
        add(value)
        @identifiers[identifier] = value unless identifier.nil?
      end
      value
    end

    # Applies a block with arithmetic operations in this Context.
    # @param arithmetic [Proc] the block that will be invoked within this Context.
    # @see Arithmetic::ArithmeticFunctionFactory
    # @return [Context] self.
    def apply(&arithmetic)
      Arithmetic.apply(self, &arithmetic)
    end

    # @param selected_vertices [Array<Vertex>] an optional array of selected
    #                                          vertices.
    # return [String] the context in dot code.
    def to_dot(selected_vertices=[])
      super("rankdir=\"LR\"; dpi=\"55\" node [style=\"filled\"]", selected_vertices)
    end
  end
end
