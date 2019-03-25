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
          process_source = RuboCop::ProcessedSource.from_file(file_path, ruby_version)
          config = RuboCop::ConfigStore.new.for(process_source.path)
          cop_classes = RuboCop::Cop::Cop.all
          registry = RuboCop::Cop::Registry.new(cop_classes)
          team = RuboCop::Cop::Team.new(registry, config)
          result[:error_count] = team.inspect_file(process_source).count
          result[:error_messages] = team.inspect_file(process_source).map(&:message)
        end
        result
      end

      private

      def self.ruby_version
        RUBY_VERSION.to_f
      end

      def self.ruby_file?(file_path)
        File.extname(file_path) == '.rb'
      end
    end
  end
end