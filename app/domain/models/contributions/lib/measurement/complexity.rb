require 'flog'

module CodePraise

  module Measurement

    module Complexity

      def self.calculate(file_path)
        result = {
          average: nil,
          methods_complexity: nil
        }
        if ruby_file?(file_path)
          flog = Flog.new
          flog.flog(*file_path)
          result[:average] = flog.average
          result[:methods_complexity] = methods_complexity(flog.totals)
        end
        result
      end

      private

      def self.methods_complexity(flog_totals)
        flog_totals.keys.inject({}) do |result, key|
          result[method_name(key)] = flog_totals[key]
          result
        end
      end

      def self.method_name(file_path)
        file_path.split("#").last
      end

      def self.ruby_file?(file_path)
        File.extname(file_path) == '.rb'
      end
    end
  end
end