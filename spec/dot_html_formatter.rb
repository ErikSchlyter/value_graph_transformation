require 'rspec/formatters/illustration_formatter.rb'
require 'open3'

RSpec.configure do |c|
  c.illustration_html_formatter =
    lambda {|illustration|
    html = "<dd>"

    if illustration.has_key?(:label) then
      html << "<span>#{illustration[:label].to_s}</span>"
    end

    if illustration[:html] then
      html << illustration[:html]
    else
      html << "<pre>#{illustration[:content]}</pre>"
    end

    return html << "</dd>"
  }
end
