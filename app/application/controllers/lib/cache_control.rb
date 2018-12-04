# frozen_string_literal: true

module CodePraise
  module Cache
    # Helps the controller set and inspect cache
    class Control
      MINUTE = 60 # seconds
      HOUR = 60 * MINUTE
      DURATION = 1 * HOUR

      def initialize(response)
        @response = response
        @on = false
      end

      def turn_on(duration = DURATION)
        @response.cache_control public: true, max_age: duration
        @on = true
      end

      def on?
        @on
      end
    end
  end
end
