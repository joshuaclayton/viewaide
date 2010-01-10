module Viewaide
  module Helpers
    module NavigationHelper
      # Generates a <li> and <a> for site navigation
      # @param [String] name the anchor text
      # @param [String] path the URL of the anchor
      # @param [Hash] options options hash for #link_to
      # @param [Hash] li_options options hash for #content_tag
      # @example
      #   <%= tab "Home", root_path %>
      #   generates
      #   <li><a href="/">Home</a></li>
      #
      #   <%= tab "Home", root_path, :compare => (controller.action_name == "show") %>
      #   generates
      #   <li class="active"><a href="/">Home</a></li>
      #
      #   <%= tab "Home", root_path, {:class => "a"}, {:class => "li"} %>
      #   generates
      #   <li class="li"><a href="/" class="a">Home</a></li>
      def tab(name, path, options = {}, li_options = {})
        opts = parse_tab_options(name, li_options)

        active = "active" if (opts[:active] == opts[:comparison]) || opts[:compare]
        css_classes = [] << opts[:li_classes] << active
        css_classes = clean_css_classes(css_classes)
        li_options.merge!(:class => css_classes) if css_classes.present?

        content_tag :li,
                    link_to(name, path, options),
                    li_options
      end

      private

      def parse_tab_options(name, li_options = {})
        returning({}) do |result|
          result[:active]     = li_options.delete(:active)         || (name.gsub(/\s/, '').tableize || "")
          result[:comparison] = li_options.delete(:active_compare) || controller.controller_name
          result[:compare]    = li_options.delete(:compare)        || false
          result[:li_classes] = li_options.delete(:class)
        end
      end
    end
  end
end
