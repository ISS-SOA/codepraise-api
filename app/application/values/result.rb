# frozen_string_literal: true

module CodePraise
  module Value
    # Value object for any operation result
    Result = Struct.new(:status, :message) do
      SUCCESS = Set.new(
        %i[ok created processing no_content]
      ).freeze

      FAILURE = Set.new(
        %i[forbidden not_found bad_request conflict cannot_process
           internal_error]
      ).freeze

      CODES = SUCCESS | FAILURE

      def initialize(status:, message:)
        raise(ArgumentError, 'Invalid status') unless CODES.include? status

        super(status, message)
      end
    end
  end
end
