module Viewaide
  module Helpers
    module MessageHelper
      # Generates paragraphs, each containing the values of the hash passed
      # @param [Hash] messages a hash (#flash, especially) that will render the values in separate paragraphs
      # @return [String]
      # @example
      #   <%= messages(:notice => "Your record was saved") %>
      #   generates
      #   <p class="notice box single-line">Your record was saved</p>
      #
      # @example
      #   <%= messages(:notice => "Your record was saved", :error => "Something happened!") %>
      #   generates
      #   <p class="notice box single-line">Your record was saved</p>
      #   <p class="error box single-line">Something happened!</p>
      def messages(messages, options = {})
        except_keys = [options[:except]].flatten.compact
        only_keys   = [options[:only]].flatten.compact

        if except_keys.any? && only_keys.any?
          raise ArgumentError, ":only and :except options conflict; use one"
        end

        keys = if except_keys.any?
          messages.keys - except_keys
        elsif only_keys.any?
          messages.keys & only_keys
        else
          messages.keys
        end

        keys.map do |key|
          if messages[key].present?
            content_tag :p,
                        messages[key],
                        :class => [key, "single-line"].join(" ")
          end
        end.join
      end

    end
  end
end
