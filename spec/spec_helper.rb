require 'rspec/illustrate'
require 'value_graph_transformation'


module ValueGraphTransformation

  # An add-on that compiles the illustration into suitable format before passing
  # it to rspec-illustrate.
  module IllustrationCompiler

    # Overrides RSpec::Illustrate.illustrate and compiles the content object
    # into dot/svg if it is a Graph or DotCompiler object.
    def illustrate(content, *args)

      if content.class < Graph::Graph then
        compiler = DotCompiler.new(content)
      elsif content.is_a?(DotCompiler) then
        compiler = content
      else
        return super(content.to_s, *args)
      end

      dot = compiler.to_dot
      svg = DotCompiler.to_svg(dot)

      args << {:html => svg}
      super(dot, *args)
    end

  end

end

