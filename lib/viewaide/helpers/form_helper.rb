module Viewaide
  module Helpers
    module FormHelper

      # Generates a submit button for forms
      #
      # @param [String] value the text for the button
      # @param [*Args]
      # @return [String]
      # @example
      #   <%= submit_button "Create" %>
      #   generates
      #   <button class="btn" type="submit" value="Create">
      #     <span>Create</span>
      #   </button>
      #
      # @example
      #   <%= submit_button "Create", :class1, :class2, "another-class" %>
      #   generates
      #   <button class="btn class1 class2 another-class" type="submit" value="Create">
      #     <span>Create</span>
      #   </button>
      #
      # @example
      #   <%= submit_button "Create", :class1, :id => "custom", :type => "image" %>
      #   generates
      #   <button class="btn class1" type="image" id="custom" value="Create">
      #     <span>Create</span>
      #   </button>
      #
      # @example
      #   <%= submit_button "Create", :class1, :value => "override" %>
      #   generates
      #   <button class="btn class1" type="submit" value="override">
      #     <span>Create</span>
      #   </button>
      def submit_button(value, *args)
        options = args.extract_options!
        css_classes = ["btn"] << options.delete(:class) << args
        css_classes = clean_css_classes(css_classes, {"last" => last_column})

        content_tag :button,
                    "<span>#{value}</span>",
                    { :value => value,
                      :type => "submit",
                      :class => css_classes
                    }.merge(options)
      end

      # Generates a wrapper set for form inputs and labels
      #
      # @param [*Args]
      # @return [String]
      # @example
      #   <% set do %>words<% end %>
      #   generates
      #   <div class="text">words</div>
      #
      # @example
      #   <% set :checkbox do %>words<% end %>
      #   generates
      #   <div class="checkbox">words</div>
      #
      # @example
      #   <% set :id => "custom-id" do %>words<% end %>
      #   generates
      #   <div class="text" id="custom-id">words</div>
      #
      # @example
      #   <% set :half do %>words<% end %>
      #   generates
      #   <div class="text span-12">words</div>
      def set(*args, &block)
        options = args.extract_options!
        css_classes = [] << options.delete(:class) << args

        if !other_than_grid?(args.map(&:to_s) - ["error", "last", last_column.to_s])
          css_classes << "text"
        end

        if standardize_css_classes(css_classes).include?("textarea")
          css_classes << "text"
        end

        css_classes = clean_css_classes(css_classes, {"last" => last_column})

        html = clean_column(css_classes) do
          content_tag :div,
                      capture(&block),
                      options.merge(:class => css_classes)
        end

        concat(html)
      end

      # Generates a fieldset with legend
      #
      # @param [*Args]
      # @return [String]
      # @example
      #   <% fieldset do %>words<% end %>
      #   generates
      #   <fieldset>words</fieldset>
      #
      # @example
      #   <% fieldset "User Information" do %>words<% end %>
      #   generates
      #   <fieldset>
      #     <h3 class="legend">User Information</h3>
      #   </fieldset>
      #
      # @example
      #   <% fieldset "User Information", :hform do %>words<% end %>
      #   generates
      #   <fieldset class="hform">
      #     <h3 class="legend">User Information</h3>
      #   </fieldset>
      #
      # @example
      #   <% fieldset "User Information", :hform, :legend => {:class => "lgnd", :id => "legend-id"} do %>
      #     words
      #   <% end %>
      #   generates
      #   <fieldset class="hform">
      #     <h3 class="legend lgnd" id="legend-id">User Information</h3>
      #     words
      #   </fieldset>
      #
      # @example
      #   <% fieldset "User Information", :hform, :id => "user-info" do %>
      #     words
      #   <% end %>
      #   generates
      #   <fieldset class="hform" id="user-info">
      #     <h3 class="legend">User Information</h3>
      #     words
      #   </fieldset>
      def fieldset(*args, &block)
        options = args.extract_options!
        css_classes = [] << options.delete(:class) << args
        title = args.shift if args.first.is_a?(String)
        legend = if title.blank?
          ""
        else
          legend_opts = options.delete(:legend) || {}
          legend_classes = clean_css_classes([legend_opts.delete(:class)] << "legend")
          content_tag :h3,
                      title,
                      {:class => legend_classes}.merge(legend_opts)
        end

        css_classes = clean_css_classes(css_classes, {"last" => last_column})

        html = clean_column(css_classes) do
          content_tag :fieldset,
                      legend + capture(&block),
                      options.merge(:class => css_classes)
        end

        concat(html)
      end

    end
  end
end
