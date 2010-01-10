module Viewaide
  module Helpers
    module DateHelper
      # Converts a date or time object to a formatted time
      #
      # @param [Date, Time, or DateTime] dt the date to convert
      # @param [String] default_text default text if the date is nil
      # @param [Symbol] format_string the time format
      # @return [String]
      def datetime(dt = nil, default_text = "", format_string = :long)
        dt ? dt.to_time.to_s(format_string) : default_text
      end

      # Converts a date or time object to a formatted date
      #
      # @param [Date, Time, or DateTime] dt the date to convert
      # @param [String] default_text default text if the date is nil
      # @param [Symbol] format_string the date format
      # @return [String]
      def date(dt = nil, default_text = "", format_string = :long)
        dt ? dt.to_date.to_s(format_string) : default_text
      end

    end
  end
end
