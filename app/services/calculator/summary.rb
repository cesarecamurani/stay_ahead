# frozen_string_literal: true

module Calculator
  class Summary < Data.define(:user)
    AMOUNTS_BY_RECURRENCE = {
      weekly:    ->(commitment) { (commitment.amount * 52) / 12 },
      monthly:   ->(commitment) { commitment.amount },
      quarterly: ->(commitment) { commitment.amount / 3 },
      yearly:    ->(commitment) { commitment.amount / 12 },
      one_time:  ->(_commitment) { BigDecimal("0") }
    }.freeze

    def call
      commitments_amount = monthly_commitments_amount

      {
        monthly_income: user.monthly_income,
        savings: user.savings,
        monthly_commitments_amount: commitments_amount,
        available_cash_flow: available_cash_flow(commitments_amount),
        savings_runway_months: savings_runway_months(commitments_amount)
      }
    end

    private

    def monthly_amount(commitment)
      formula = AMOUNTS_BY_RECURRENCE.fetch(commitment.recurrence.to_sym)

      formula.call(commitment)
    end

    def monthly_commitments_amount
      active_commitments.sum do |commitment|
        monthly_amount(commitment)
      end
    end

    def available_cash_flow(monthly_commitments_amount)
      return if user.monthly_income.nil?

      user.monthly_income - monthly_commitments_amount
    end

    def savings_runway_months(monthly_commitments_amount)
      return if user.savings.nil?
      return if monthly_commitments_amount.zero?

      user.savings / monthly_commitments_amount
    end

    def active_commitments
      user.commitments.select(&:currently_active?)
    end
  end
end
