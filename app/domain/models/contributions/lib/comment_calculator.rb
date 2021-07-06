# frozen_string_literal: true

module CodePraise
  module Mixins
    # Comment and multiline comment calculator
    module CommentCalculator
      MULTILINE = 2
      COMMENT = '#'

      def multiline_comment_count
        count_comments(:multiline_comment?, lines_of_code)
      end

      def singleline_comment_count
        count_comments(:singleline_comment?, lines_of_code)
      end

      def count_comments(condition, lines_of_code)
        comment_index = not_comment_index = documentation = -1
        lines_of_code.each_with_index do |loc, i|
          if comment?(loc)
            comment_index = i
          else
            documentation += 1 if method(condition).call(comment_index, not_comment_index)
            not_comment_index = i
          end
        end
        documentation += 1 if method(condition).call(comment_index, not_comment_index)
        documentation
      end

      private

      def lines_of_code
        lines.map(&:code)
      end

      def singleline_comment?(comment_index, not_comment_index)
        (comment_index - not_comment_index) == 1
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
