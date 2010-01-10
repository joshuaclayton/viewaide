module Viewaide
  module Helpers
    module StructureHelper

      # Generate a blockquote
      # @param [*Args]
      # @return [String]
      # @example
      #   <% blockquote do %>Quoted text<% end %>
      #   generates
      #   <blockquote>Quoted text</blockquote>
      #
      # @example
      #   <% blockquote :author => "W. Shakespeare" do %>All the world's a stage<% end %>
      #   generates
      #   <div class="quote-cited">
      #     <blockquote>All the world's a stage</blockquote>
      #     <cite>W. Shakespeare</cite>
      #   </div>
      def blockquote(*args, &block)
        options = args.extract_options!
        author = options.delete(:author)
        option_quote = textilize(options.delete(:quote))

        bq =  content_tag :blockquote,
                          option_quote.blank? ? capture(&block) : option_quote

        html = if author
          content_tag :div,
                      bq + content_tag(:cite, author),
                      :class => "quote-cited"
        else
          bq
        end

        concat(html)
      end

      # Allows assignment of <body> attributes.
      # The body (when accepting a block) should be used in your application's layout
      # @param [*Args]
      # @return [String]
      # @example
      #   <% body do %>body goes here<% end %>
      #   generates
      #   <body>body goes here</body>
      #
      # @example
      #   <% body :home, "logged-in", :id => "application" do %>body goes here<% end %>
      #   generates
      #   <body class="home logged-in" id="application">body goes here</body>
      #
      # @example
      #   <% body :home, "logged-in" %> # within an ERB template
      #   <% body :id => "application" %> # within a different ERB template
      #   <% body do %>body goes here<% end %> # within application layout
      #   generates
      #   <body class="home logged-in" id="application">body goes here</body>
      def body(*args)
        options = args.extract_options!
        @_page_body_attributes ||= {}

        css_classes = [] << @_page_body_attributes.delete(:class) << args

        @_page_body_attributes = @_page_body_attributes.merge(options)
        @_page_body_attributes[:class] = clean_css_classes(css_classes)

        if block_given?
          block = lambda { yield }

          html = content_tag(:body, capture(&block), @_page_body_attributes)
          concat(html)
        end
      end

    end
  end
end
