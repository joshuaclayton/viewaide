module Viewaide
  module Helpers
    module JqueryHelper
      # generates a script tag with the appropriate type,
      # an anonymous function (assigning jQuery to $),
      # and within a #ready callback
      #
      # @param [block] &block the block of text to wrap
      # @return [String]
      # @example
      #   <% document_ready do %>
      #     $("a[rel=external]").live(function() {
      #       $(this).attr({target: "_blank"});
      #     });
      #   <% end %>
      #   generates
      #   <script type="text/javascript">
      #     (function($) {
      #       $(document).ready(function() {
      #         $("a[rel=external]").live(function() {
      #           $(this).attr({target: "_blank"});
      #         });
      #       });
      #     })(jQuery);
      #   </script>
      def document_ready(&block)
        html = content_tag :script, :type => "text/javascript" do
          %(
            (function($) {
              $(document).ready(function() {
                #{capture(&block)}
              });
            })(jQuery);
          )
        end

        concat(html)
      end

    end
  end
end
