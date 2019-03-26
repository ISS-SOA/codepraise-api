# frozen_string_literal: true
require 'rubocop'

module CodePraise

  module Measurement

    module Idiomaticity

      def self.calculate(file_path)
        result = {
          error_count: nil,
          error_messages: nil
        }
        if ruby_file?(file_path)
          rubocop_result = rubocop_process(file_path)
          result[:error_count] = rubocop_result.count
          result[:error_messages] = rubocop_result.map(&:message)
        end
        result
      end

      private

      def self.rubocop_process(file_path)
        process_source = RuboCop::ProcessedSource.from_file(file_path, ruby_version)
        config = RuboCop::ConfigStore.new.for(process_source.path)
        cop_classes = RuboCop::Cop::Cop.all
        registry = RuboCop::Cop::Registry.new(cop_classes)
        team = RuboCop::Cop::Team.new(registry, config)
        team.inspect_file(process_source)
      end

      def self.ruby_version
        RUBY_VERSION.to_f
      end

      def self.ruby_file?(file_path)
        File.extname(file_path) == '.rb'
      end
    end
  end
end