# frozen_string_literal: true

folders = %w[github database git cache messaging]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
