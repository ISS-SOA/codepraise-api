# frozen_string_literal: true

folders = %w[representers]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
