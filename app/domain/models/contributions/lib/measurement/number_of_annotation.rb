# frozen_string_literal: true

module CodePraise

  module Measurement

    module NumberOfAnnotation

      LINE_LIMITATION = 2
      COMMENT = "#"

      def self.calculate(lines)
        comment_index, not_comment_index, annotation = [0, 0, 0]
        lines.each_with_index do |loc, i|
          if is_comment?(loc)
            comment_index = i
          else
            annotation += 1 if multiline_comment?(comment_index, not_comment_index)
            not_comment_index = i
          end
        end
        annotation += 1 if multiline_comment?(comment_index, not_comment_index)
        annotation
      end

      private

      def self.multiline_comment?(comment_index, not_comment_index)
        (comment_index - not_comment_index) >= LINE_LIMITATION
      end

      def self.is_comment?(loc)
        loc.strip[0] == COMMENT
      end

    end
  end
end