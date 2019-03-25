# frozen_string_literal: true

folders = %w[lib config app]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
