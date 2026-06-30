# frozen_string_literal: true

require "rails_helper"

RSpec.describe Calculator::MonthlyAmount do
  subject(:monthly_amount) { described_class }

  describe ".call" do
    recurrences = {
      weekly:    { amount: 15, expected: BigDecimal("65") },
      monthly:   { amount: 50, expected: BigDecimal("50") },
      quarterly: { amount: 300, expected: BigDecimal("100") },
      yearly:    { amount: 600, expected: BigDecimal("50") },
      one_time:  { amount: 1000, expected: BigDecimal("0") }
    }

    recurrences.each do |recurrence, values|
      context "with a #{recurrence} recurrence commitment" do
        let(:commitment) do
          instance_double(
            "Commitment",
            recurrence: recurrence.to_s,
            amount: BigDecimal(values[:amount].to_s)
          )
        end

        it "calculates the correct monthly amount" do
          expect(monthly_amount.call(commitment)).to eq(values[:expected])
        end
      end
    end

    context "with an unknown recurrence" do
      let(:commitment) do
        instance_double(
          "Commitment",
          recurrence: "daily",
          amount: BigDecimal("5")
        )
      end

      it "raises an error" do
        expect { monthly_amount.call(commitment) }.to raise_error(KeyError)
      end
    end
  end
end
