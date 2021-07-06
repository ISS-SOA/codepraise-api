# frozen_string_literal: true

folders = %w[metrics children root]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
