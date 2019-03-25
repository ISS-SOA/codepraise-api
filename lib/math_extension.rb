# frozen_string_literal: true

module Math
  def self.coefficient_variation(nums)
    (sigma(nums) / mean(nums) * 100).round
  end

  def self.sigma(nums)
    Math.sqrt(variance(nums))
  end

  def self.variance(nums)
    m = mean(nums)
    sum = 0.0
    nums.each {|v| sum += (v-m)**2 }
    (sum/nums.size).round(3)
  end

  def self.mean(nums)
    nums.reduce(:+).to_f / nums.count
  end
end