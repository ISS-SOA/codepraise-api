module CodePraise
  module Mapper
    class Idiomaticity
      def initialize(git_repo_path)
        @rubocop_reporter = Rubocop::Reporter.new(git_repo_path)
      end

      def build_entity(file_path)
        Entity::Idiomaticity.new(
          offenses: offenses(file_path)
        )
      end

      private

      def offenses(file_path)
        idiomaticity_result = @rubocop_reporter.report[file_path]

        return nil if idiomaticity_result.nil?

        idiomaticity_result.map do |error_hash|
          Entity::Offense.new(
            type: error_hash['cop_name'],
            message: error_hash['message'],
            location: error_hash['location']['start_line']
          )
        end
      end
    end
  end
end
