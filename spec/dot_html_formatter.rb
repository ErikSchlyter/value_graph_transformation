require 'rspec/formatters/illustration_formatter.rb'
require 'open3'

def dot_to_svg(dot)
  svg = nil
  Open3.popen3("dot -Tsvg") { |stdin, stdout, stderr, wait_thr|
    stdin.print(dot)
    stdin.close
    svg = stdout.read
    $stderr.puts stderr.read
    exit_status = wait_thr.value # Process::Status object returned.
  }
  return svg
end

RSpec.configure do |c|
  c.illustration_html_formatter =
    lambda {|illustration|
    html = "<dd>"

    if illustration.has_key?(:label) then
      html << "<span>#{illustration[:label].to_s}</span>"
    end

    content = illustration[:content]
    if content.start_with?("digraph {") && (svg = dot_to_svg(content)) then
      html << svg
    else
      html << "<pre>#{content.to_s}</pre>"
    end

    return html << "</dd>"
  }
end
