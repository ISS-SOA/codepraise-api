# frozen_string_literal: true

folders = %w[github database git cache]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
