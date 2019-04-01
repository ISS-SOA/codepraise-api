# frozen_string_literal: true

module CodePraise
  module Mixins
    # Calculate coefficient variantion of subfolder contribution
    module CodeOnwershipCalculator
      def coefficient_variation
        return nil unless any_subfolders?

        contributors_percentage_hash = contributros_subfolders_percentage
        contributors_percentage_hash.each do |k, v|
          contributors_percentage_hash[k] = Math.coefficient_variation(v)
        end
        contributors_percentage_hash
      end

      private

      def contributros_subfolders_percentage
        percentage_array = subfolders.map do |subfolder|
          subfolder.credit_share.share_percentage
        end
        contributors_hash = contributors.each_with_object({}) {|contributor, hash| hash[contributor.username] = []; hash}
        percentage_array.each do |subfolder_percentage|
          contributors_hash.keys.each do |k|
            contributors_hash[k]
              .push(subfolder_percentage[k].nil? ? 0 : subfolder_percentage[k])
          end
        end
        contributors_hash
      end
    end
  end
end
