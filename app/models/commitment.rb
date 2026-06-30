# frozen_string_literal: true

class Commitment < ApplicationRecord
  belongs_to :user

  enum :category, {
    obligation: 0,   # rent, mortgage, essential fixed costs
    debt: 1,         # loans, installments, credit repayments
    service: 2,      # subscriptions, insurance (for now)
    investment: 3    # pension, funds, investing flows
  }

  enum :status, {
    active: 0,
    inactive: 1,
    completed: 2
  }

  enum :recurrence, {
    one_time: 0,
    weekly: 1,
    monthly: 2,
    quarterly: 3,
    yearly: 4
  }

  validates :name, presence: true
  validates :category, presence: true
  validates :recurrence, presence: true
  validates :status, presence: true
  validates :interest_rate, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :duration_months, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :start_date, presence: true

  def currently_active?(date = Date.current)
    return false unless active?
    return false if start_date > date

    return true if duration_months.blank?

    start_date.advance(months: duration_months) > date
  end
end
