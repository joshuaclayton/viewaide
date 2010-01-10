module Viewaide
  module Helpers
    module GridHelper
      MULTIPLES = {
        :one_twentyfourth =>          (1/24.to_f),
        :one_twelfth =>               (1/12.to_f),
        :one_eigth =>                 (1/8.to_f),
        :one_sixth =>                 (1/6.to_f),
        :five_twentyfourths =>        (5/24.to_f),
        :one_fourth =>                (1/4.to_f),
        :seven_twentyfourths =>       (7/24.to_f),
        :one_third =>                 (1/3.to_f),
        :three_eigths =>              (3/8.to_f),
        :five_twelfths =>             (5/12.to_f),
        :eleven_twentyfourths =>      (11/24.to_f),
        :one_half =>                  (1/2.to_f),
        :half =>                      (1/2.to_f),
        :thirteen_twentyfourths =>    (13/24.to_f),
        :seven_twelfths =>            (7/12.to_f),
        :five_eigths =>               (5/8.to_f),
        :two_thirds =>                (2/3.to_f),
        :seventeen_twentyfourths =>   (17/24.to_f),
        :three_fourths =>             (3/4.to_f),
        :nineteen_twentyfourths =>    (19/24.to_f),
        :five_sixths =>               (5/6.to_f),
        :seven_eigths =>              (7/8.to_f),
        :eleven_twelfths =>           (11/12.to_f),
        :twentythree_twentyfourths => (23/24.to_f),
        :full =>                      (1.to_f)
      }.freeze
      MULTIPLE_FRACTIONS = MULTIPLES.keys.map {|key| key.to_s }.freeze

      # force use of Easel-style classes
      def self.easel_grid!
        @@last_column = "col-last"
        @@column_prefix = "col"
      end

      # force use of Blueprint-style classes (the default)
      def self.blueprint_grid!
        @@last_column = "last"
        @@column_prefix = "span"
      end

      blueprint_grid!

      # @return [String] last column (based on Blueprint or Easel grid formats)
      def last_column
        @@last_column
      end

      # Returns a div with the correct width-calculated class
      # @param [*Args]
      # @return [String]
      # @example
      #   <% column do %>Full column<% end %>
      #   generates
      #   <div class="span-24">Full column</div>
      #
      # @example
      #   <% column do %>
      #     <% column :half do %>column<% end %>
      #   <% end %>
      #   generates
      #   <div class="span-24">
      #     <div class="span-12">column</div>
      #   </div>
      #
      # @example
      #   <% column :one_third do %>one third<% end %>
      #   <% column :two_thirds, :last do %>two thirds<% end %>
      #   generates
      #   <div class="span-8">one third</div>
      #   <div class="span-16 last">two thirds</div>
      #
      # @example
      #   <% column :one_third, :custom, :id => "column" do %>words<% end %>
      #   generates
      #   <div class="span-8 custom" id="column">words</div>
      def column(*args, &block)
        @_viewaide_column_count ||= application_width
        col(*args, &block)
      end

      # Wraps content in a container
      # @param [Symbol] size size of the container
      # @return [String]
      # @example
      #   <% container do %>content<% end %>
      #   generates
      #   <div class="container">content<% end %>
      #
      # @example
      #   <% container :half do %>content<% end %>
      #   generates
      #   <div class="container span-12">content<% end %>
      def container(size=nil, *args, &block)
        opts = args.extract_options!
        opts.merge!(:suppress_col => true) if size.nil?
        args = args.insert(0, :container)
        column(size, *([args, opts].flatten), &block)
      end

      def clean_column(classes, &block)
        size = classes.scan(/#{column_prefix}-(\d+)/).flatten.last

        if size.nil?
          html = capture(&block)
          if block_given? && block_is_within_action_view?(block)
            concat(html)
          else
            html
          end
        else
          size = size.to_i
          increase_depth(size)
          html = capture(&block)

          if block_given? && block_is_within_action_view?(block)
            concat(html)
            decrease_depth(size)
          else
            decrease_depth(size)
            html
          end
        end
      end

      def method_missing_with_viewaide_widths(call, *args)
        # filter out any initial helper calls
        found = false
        MULTIPLE_FRACTIONS.each do |fraction|
          found = true and break if call.to_s.include?(fraction)
        end

        method_missing_without_viewaide_widths(call, *args) and return unless found

        # one of the widths is somewhere in the helper call; let's find it
        call.to_s =~ /^((append|prepend|#{column_prefix})_)?(.+)$/
        class_name = $2 || column_prefix
        class_width = $3

        if MULTIPLES.keys.include?(class_width.to_sym)
          width = @_viewaide_column_count || application_width
          "#{class_name}-#{(width*MULTIPLES[class_width.to_sym]).to_i}"
        else
          method_missing_without_viewaide_widths(call, *args)
        end
      end

      alias_method_chain :method_missing, :viewaide_widths

      private

      def application_width; 24; end

      def increase_depth(size)
        @_viewaide_current_width ||= [application_width.to_s]

        if @_viewaide_column_count.present?
          @_viewaide_current_width.push(@_viewaide_column_count.to_s)
        end

        @_viewaide_column_count = if size.to_s =~ /^\d+$/
          size.to_s.to_i
        else
          (@_viewaide_column_count*MULTIPLES[size]).to_i
        end
      end

      def decrease_depth(size)
        @_viewaide_column_count = if size.is_a?(Integer)
          @_viewaide_current_width.last.to_i
        else
          (@_viewaide_column_count/MULTIPLES[size]).to_i
        end

        @_viewaide_current_width.pop
      end

      def col(*args, &block)
        fractional_width = MULTIPLE_FRACTIONS.include?(args.first.to_s)
        explicit_column_width = args.first.is_a?(Integer)
        size = (fractional_width || explicit_column_width) ? args.shift : :full

        increase_depth(size)
        output_tag = generate_output_tag(size, *args, &block)

        if block_given? && block_is_within_action_view?(block)
          concat(output_tag)
          decrease_depth(size)
        else
          decrease_depth(size)
          output_tag
        end
      end

      def generate_output_tag(size, *args, &block)
        options = args.extract_options!

        css_classes = [] << options.delete(:class) << args
        unless options.delete(:suppress_col)
          css_classes << "#{column_prefix}-#{@_viewaide_column_count}"
        end

        if (size.to_sym rescue nil) == :full && @_viewaide_column_count != application_width
          css_classes << last_column
        end

        css_classes = clean_css_classes(css_classes, {"last" => last_column})
        content_tag(options.delete(:tag) || :div,
                    capture(&block),
                    {:class => css_classes}.merge(options))
      end

      def column_prefix
        @@column_prefix
      end
    end
  end
end
