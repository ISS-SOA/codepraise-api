# frozen_string_literal: true

class Sequel::Model
  def save!
    self.save && true
  end
end

Dir.glob("#{File.dirname(__FILE__)}/*.rb").each do |file|
  require file
end
