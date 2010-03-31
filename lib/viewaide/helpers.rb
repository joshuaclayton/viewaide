require "viewaide/helpers/date_helper"
require "viewaide/helpers/link_helper"
require "viewaide/helpers/structure_helper"
require "viewaide/helpers/table_helper"
require "viewaide/helpers/grid_helper"
require "viewaide/helpers/message_helper"
require "viewaide/helpers/rjs_helper"
require "viewaide/helpers/jquery_helper"

module Viewaide
  module Helpers
    include DateHelper
    include LinkHelper
    include StructureHelper
    include TableHelper
    include GridHelper
    include MessageHelper
    include RjsHelper
    include JqueryHelper

    protected

    def other_than_grid?(classes)
      (standardize_css_classes(classes).map {|css_class| css_class.to_s } -
       Viewaide::Helpers::GridHelper::MULTIPLE_FRACTIONS).any?
    end

    def clean_css_classes(string_or_array, replace = {})
      css_classes = [] + standardize_css_classes(string_or_array)

      if replace.any?
        replace_css_classes(css_classes, replace)
      end

      fractions = css_classes & Viewaide::Helpers::GridHelper::MULTIPLE_FRACTIONS
      if css_classes.any? && fractions.any?
        replace_fractions(css_classes, fractions)
      end

      css_classes.map(&:strip).reject(&:blank?).uniq.join(" ").strip
    end

    private

    def standardize_css_classes(string_or_array)
      [string_or_array].flatten.join(" ").split(/ /)
    end

    def replace_css_classes(css_classes, replace)
      replace.keys.each do |key|
        if css_classes.include?(key)
          css_classes.delete(key)
          css_classes << replace[key]
        end
      end
    end

    def replace_fractions(css_classes, fractions)
      fractions.each do |fraction|
        css_classes.delete(fraction)
        css_classes << self.send(fraction)
        if fraction == "full" && @_viewaide_column_count != application_width
          css_classes << last_column
        end
      end
    end

    BLOCK_CALLED_FROM_ERB = 'defined? __in_erb_template'

    if RUBY_VERSION < '1.9.0'
      # Check whether we're called from an erb template.
      # We'd return a string in any other case, but erb <%= ... %>
      # can't take an <% end %> later on, so we have to use <% ... %>
      # and implicitly concat.
      def block_is_within_action_view?(block)
        block && eval(BLOCK_CALLED_FROM_ERB, block)
      end
    else
      def block_is_within_action_view?(block)
        block && eval(BLOCK_CALLED_FROM_ERB, block.binding)
      end
    end

  end
end
