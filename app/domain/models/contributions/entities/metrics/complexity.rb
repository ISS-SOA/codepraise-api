# frozen_string_literal: true
require 'flog'

module CodePraise

  module Entity

    class Complexity

      def initialize(file_path:)
        return nil unless ruby_file?(file_path)
        @flog = Flog.new
        @flog.flog(*file_path)
      end

      def average
        @flog.average
      end

      def methods_score
        methods_score = @flog.totals
        methods_score.keys.inject({}) do |result, file_path|
          result[method_name(file_path)] = @flog.totals[file_path]
          result
        end
      end

      private

      def ruby_file?(file_path)
        File.extname(file_path) == '.rb'
      end

      def method_name(file_path)
        file_path.split("#").last
      end
    end
  end
end
