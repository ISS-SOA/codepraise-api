# frozen_string_literal: true

module CodePraise
  # Helps the application query environment
  class Env
    def initialize(app_klass)
      @environment = app_klass.environment
    end

    def production?
      @environment == :production
    end
  end
end
