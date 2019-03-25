# frozen_string_literal: true

require_relative 'line_contribution'
require 'dry-types'
require 'dry-struct'

module CodePraise
  module Entity
    # Entity for a single method contributed by a team-member
    class MethodContribution < Dry::Struct

      include Dry::Types.module

      attribute :name, Coercible::String
      attribute :lines, Array.of(LineContribution)

      def credit_share
        @credit_share ||= lines.each_with_object(Value::CreditShare.new) do |line, credit|
          credit.add_credit(line)
        end
      end

      def share
        credit_share.share
      end

      def contributors
        credit_share.contributors
      end
    end
  end
end
