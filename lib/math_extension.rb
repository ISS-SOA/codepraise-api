# frozen_string_literal: true

# Math
module Math
  def self.coefficient_variation(nums)
    return nil if mean(nums).zero?

    (sigma(nums) / mean(nums) * 100).round
  end

  def self.sigma(nums)
    Math.sqrt(variance(nums))
  end

  def self.variance(nums)
    return nil if nums.count.zero?

    m = mean(nums)
    sum = 0.0
    nums.each {|v| sum += (v-m)**2 }
    (sum/nums.size).round(3)
  end

  def self.mean(nums)
    return nil if nums.count.zero?

    nums.reduce(:+).to_f / nums.count
  end
end