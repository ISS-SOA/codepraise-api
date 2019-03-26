# frozen_string_literal: true

module CodePraise

  module Measurement

    module CollectiveOwnership

      def self.calculate(sub_folders, contributor_entities)
        subfolders_percentage_hash = subfolders_percentage(sub_folders, contributor_entities)
        subfolders_percentage_hash.keys.inject([]) do |result, name|
          result.push(
            {
              contributor: name,
              contributions: subfolders_percentage_hash[name],
              coefficient_variation: Math.coefficient_variation(percentage_nums(subfolders_percentage_hash[name]))
            }
          )
        end
      end

      private

      def self.subfolders_percentage(sub_folders, contributor_entities)
        contributors = contributor_empty_hash(contributor_entities)
        sub_folders.each do |subfolder|
          contributors.each do |name, v|
            share_percentage = subfolder.credit_share.share_percentage
            break if share_percentage.nil?
            contributors[name].push({percentage: (share_percentage[name].nil? ? 0 : share_percentage[name]), folder: subfolder.path})
          end
        end
        contributors
      end

      def self.contributor_empty_hash(contributor_entities)
        contributor_entities.inject({}) {|hash, contributor| hash[contributor.username] = []; hash}
      end

      def self.percentage_nums(percentage_array)
        percentage_array.map{|percentage_hash| percentage_hash[:percentage]}
      end
    end
  end
end