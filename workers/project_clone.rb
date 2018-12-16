# frozen_string_literal: true

module GitClone
  # Infrastructure to clone while yielding progress
  module CloneMonitor
    CLONE_PROGRESS = {
      'STARTED'   => 15,
      'Cloning'   => 30,
      'remote'    => 70,
      'Receiving' => 85,
      'Resolving' => 95,
      'Checking'  => 100,
      'FINISHED'  => 100
    }.freeze

    def self.starting_percent
      CLONE_PROGRESS['STARTED'].to_s
    end

    def self.finished_percent
      CLONE_PROGRESS['FINISHED'].to_s
    end

    def self.progress(line)
      CLONE_PROGRESS[first_word_of(line)].to_s
    end

    def self.percent(stage)
      CLONE_PROGRESS[stage].to_s
    end

    def self.first_word_of(line)
      line.match(/^[A-Za-z]+/).to_s
    end
  end
end
