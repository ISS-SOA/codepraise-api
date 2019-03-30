# frozen_string_literal: true

module CodePraise

  module Measurement

    module CollectiveOwnership

      def self.calculate(folder)
        contributors = folder.contributors
        contributors_percentage_hash = contributros_subfolders_percentage(folder.subfolders, contributors)
        contributors_percentage_hash.each do |k, v|
          contributors_percentage_hash[k] = Math.coefficient_variation(v)
        end
        contributors_percentage_hash
      end

      private
      def self.contributros_subfolders_percentage(subfolders, contributors)
        percentage_array = subfolders.map do |subfolder|
          subfolder.credit_share.share_percentage
        end
        contributors_hash = contributors.inject({}) {|hash, contributor| hash[contributor.username] = []; hash}
        percentage_array.each do |subfolder_percentage|
          contributors_hash.keys.each do |k|
            contributors_hash[k].push(subfolder_percentage[k].nil? ? 0 : subfolder_percentage[k])
          end
        end
        contributors_hash
      end
    end
  end
end