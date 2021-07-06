# frozen_string_literal: true

folders = %w[github database git cache messaging flog rubocop]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
