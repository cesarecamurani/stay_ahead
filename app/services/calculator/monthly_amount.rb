# frozen_string_literal: true

module Calculator
  class MonthlyAmount
    AMOUNTS_BY_RECURRENCE = {
      weekly:    ->(commitment) { (commitment.amount * 52) / 12 },
      monthly:   ->(commitment) { commitment.amount },
      quarterly: ->(commitment) { commitment.amount / 3 },
      yearly:    ->(commitment) { commitment.amount / 12 },
      one_time:  ->(_commitment) { BigDecimal("0") }
    }.freeze

    def self.call(commitment)
      formula = AMOUNTS_BY_RECURRENCE.fetch(commitment.recurrence.to_sym)

      formula.call(commitment)
    end
  end
end
