# frozen_string_literal: true

module CodePraise

  module Measurement

    module CollectiveOwnership

      def self.calculate(sub_folders, contributors)
        subfolders_percentage_hash = subfolders_percentage(sub_folders, contributors)
        subfolders_percentage_hash.keys.inject([]) do |result, key|
          result.push(
            {
              contributor: key,
              contributions: subfolders_percentage_hash[key],
              coefficient_variation: Math.coefficient_variation(percentage_nums(subfolders_percentage_hash[key]))
            }
          )
        end
      end

      private

      def self.subfolders_percentage(sub_folders, contributors)
        result = contributors.inject({}) {|hash, contributor| hash[contributor.username] = []; hash}
        sub_folders.each do |subfolder|
          result.each do |k, v|
            share_percentage = subfolder.credit_share.share_percentage
            break if share_percentage.nil?
            result[k].push({percentage: (share_percentage[k].nil? ? 0 : share_percentage[k]), folder: subfolder.path})
          end
        end
        result
      end

      def self.percentage_nums(percentage_array)
        percentage_array.map{|percentage_hash| percentage_hash[:percentage]}
      end
    end
  end
end