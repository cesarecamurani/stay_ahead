# frozen_string_literal: true

FactoryBot.define do
  factory :commitment do
    user
    name { "Netflix Subscription" }
    category { :obligation }
    recurrence { :monthly }
    status { :active }
    amount { 15.0 }
    start_date { Date.today - 7.days }
    interest_rate { 0.0 }
    duration_months { 12 }
  end
end
