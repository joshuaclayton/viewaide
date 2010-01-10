module ActionView
  module Partials
    private

    def render_partial_with_viewaide(*args)
      path = args.first[:partial]
      locals = args.last || {}

      viewaide_cached_column_counts = session[:viewaide_cached_column_counts] ||= {}

      if viewaide_cached_column_counts.keys.include?(path)
        @_viewaide_column_count = locals[:viewaide_width] || viewaide_cached_column_counts[path]
        viewaide_cached_column_counts[path] = @_viewaide_column_count
      else
        if @_viewaide_column_count.is_a?(Fixnum) && path !~ /^layout/
          viewaide_cached_column_counts[path] = @_viewaide_column_count
        end
      end

      render_partial_without_viewaide(*args)
    end

    alias_method_chain :render_partial, :viewaide
  end
end

module Viewaide
  module PartialCaching
    def self.included(base)
      base.send :include, Viewaide::PartialCaching::InstanceMethods
      base.before_filter :clear_viewaide_cache
    end

    module InstanceMethods
      def clear_viewaide_cache
        session[:viewaide_cached_column_counts] = nil unless request.xhr?
      end
    end
  end
end
