# frozen_string_literal: true
require 'rubocop'

module CodePraise

  module Entity

    class Idiomaticity

      def initialize(file_path:)
        return nil unless ruby_file?(file_path)
        process_source = RuboCop::ProcessedSource.from_file(file_path, ruby_version)
        config = RuboCop::ConfigStore.new.for(process_source.path)
        cop_classes = RuboCop::Cop::Cop.all
        registry = RuboCop::Cop::Registry.new(cop_classes)
        team = RuboCop::Cop::Team.new(registry, config)
        @result = team.inspect_file(process_source)
      end

      def count
        @result.count
      end

      def messages
        @result.map(&:message)
      end

      private

      def ruby_file?(file_path)
        File.extname(file_path) == '.rb'
      end

      def ruby_version
        RUBY_VERSION.to_f
      end
    end
  end
end
