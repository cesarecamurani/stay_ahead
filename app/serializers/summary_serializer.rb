# frozen_string_literal: true

class SummarySerializer < BaseSerializer
  def serialize
    {
      summary: {
        monthly_income: money(object[:monthly_income]),
        savings: money(object[:savings]),
        monthly_commitments_amount: money(object[:monthly_commitments_amount]),
        available_cash_flow: money(object[:available_cash_flow]),
        savings_runway_months: decimal(object[:savings_runway_months])
      }
    }
  end
end
