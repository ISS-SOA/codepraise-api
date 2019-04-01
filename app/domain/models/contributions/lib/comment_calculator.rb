# frozen_string_literal: true

module CodePraise
  module Mixins
    # Comment and multiline comment calculator
    module CommentCalculator
      MULTILINE = 2
      COMMENT = '#'

      def multiline_comments
        comment_index = not_comment_index = documentation = 0
        lines_of_code.each_with_index do |loc, i|
          if comment?(loc)
            comment_index = i
          else
            documentation += 1 if multiline_comment?(comment_index, not_comment_index)
            not_comment_index = i
          end
        end
        documentation += 1 if multiline_comment?(comment_index, not_comment_index)
        documentation
      end

      def comments
        lines_of_code.select do |loc|
          comment?(loc)
        end.count
      end

      private

      def lines_of_code
        lines.map(&:code)
      end

      def multiline_comment?(comment_index, not_comment_index)
        (comment_index - not_comment_index) >= MULTILINE
      end

      def comment?(loc)
        loc.strip[0] == COMMENT
      end
    end
  end
end
