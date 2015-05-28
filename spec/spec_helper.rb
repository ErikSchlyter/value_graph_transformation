require 'rspec/illustrate'
require 'value_graph_transformation'
require 'method_source'


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
      elsif content.is_a?(Proc) then
        return super(source_illustration(content), *args)
      else
        return super(content.to_s, *args)
      end

      dot = compiler.to_dot
      svg = DotCompiler.to_svg(dot)

      args << {:html => svg}
      super(dot, *args)
    end

    # Gets the source code of the given Proc with first and last lines cropped.
    # @return [String]
    def source_illustration(prc)
      lines = prc.source.split("\n")[1..-2] # crop first and last line

      indentation = lines.inject(nil) {|min, line|
        spaces = line[/\A */].size
        (!min || min > spaces) ? spaces : spaces
      }
      lines.collect{|line| line[indentation..-1]}.join("\n")
    end

  end

end

