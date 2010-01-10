module Viewaide
  module Helpers
    module LinkHelper

      # Generates a link that's able to be styled like a button.
      # This functions exactly like Rails' #link_to but wraps the link text
      # in a span and assigns a class of "btn"
      #
      # @param [*Args]
      # @return [String]
      # @example
      #   <%= link_button "Text", root_path %>
      #   generates
      #   <a href="/" class="btn"><span>Text</span></a>
      #
      # @example
      #   <%= link_button "Text", root_path, :class => "extra" %>
      #   generates
      #   <a href="/" class="btn extra"><span>Text</span></a>
      def link_button(*args, &block)
        doc = Hpricot(link_to(*args, &block))
        doc.at("a").inner_html = "<span>#{doc.at("a").inner_html}</span>"
        (doc/:a).add_class("btn")
        doc.to_html
      end

      # Generates a link to an email address.
      # This functions exactly like Rails' #link_to but changes the href to include "mailto:"
      # @param [String] email_address the email address for the link
      # @param [*Args]
      # @return [String]
      # @example
      #   <%= link_to_email "abc@def.com" %>
      #   generates
      #   <a href="mailto:abc@def.com">abc@def.com</a>
      #
      # @example
      #   <%= link_to_email "abc@def.com", "John Doe" %>
      #   generates
      #   <a href="mailto:abc@def.com">John Doe</a>
      #
      # @example
      #   <%= link_to_email "abc@def.com", "John Doe", :class => "extra" %>
      #   generates
      #   <a href="mailto:abc@def.com" class="extra">John Doe</a>
      def link_to_email(email_address, *args)
        options = args.extract_options!
        link = args.first.is_a?(String) ? h(args.first) : email_address
        return link if email_address.blank?
        link_to link, "mailto:#{email_address}", options
      end

    end
  end
end
