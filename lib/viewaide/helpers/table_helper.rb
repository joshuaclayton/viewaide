module Viewaide
  module Helpers
    module TableHelper

      # Generates <tr> elements with alternating classes
      # @param [Hash] options options passed for classes to cycle through
      # @return [String]
      # @example
      #   <% zebra_row do %>no class<% end %><% zebra_row do %>alt class<% end %>
      #   generates
      #   <tr>no class</tr>
      #   <tr class="even">alt class</tr>
      #
      # @example
      #   <% (colors = %w(red white blue)).each do |color| %>
      #     <% zebra_row :cycle_list => colors do %>the color <%= color %><% end %>
      #   <% end %>
      #   generates
      #   <tr class="red">the color red</tr>
      #   <tr class="white">the color white</tr>
      #   <tr class="blue">the color blue</tr>
      def zebra_row(options = {}, &block)
        cycle_list = options.delete(:cycle_list) || [nil, "even"]
        css_classes = [cycle(*cycle_list)] << options.delete(:class)
        css_classes = clean_css_classes(css_classes)

        html = content_tag :tr,
                           capture(&block),
                           options.merge(:class => css_classes)
        concat(html)
      end

      # Generates a <table>
      # @param [*Args]
      # @return [String]
      # @example
      #   <% recordset do %>
      #     <tbody>
      #     </tbody>
      #   <% end %>
      #   generates
      #   <table class="recordset" cellspacing="0">
      #     <tbody>
      #     </tbody>
      #   </table>
      def recordset(*args, &block)
        options = args.extract_options!
        options[:table] ||= {}

        table_classes = ["recordset", args] << options[:table].delete(:class)
        css_classes = clean_css_classes(table_classes, {"last" => last_column})

        html = clean_column(css_classes) do
          table_options = options[:table]
          table_options.merge!(:class => css_classes, :cellspacing => 0)
          content_tag(:table, capture(&block), table_options)
        end

        reset_cycle
        concat(html)
      end

    end
  end
end
