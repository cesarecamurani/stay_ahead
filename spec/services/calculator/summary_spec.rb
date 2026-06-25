# frozen_string_literal: true

require "rails_helper"

RSpec.describe Calculator::Summary do
  subject(:summary) { described_class.new(user) }

  let(:user) { instance_double("User", monthly_income: 5000, savings: 10000) }
  let(:commitment) do
    instance_double(
      "Commitment",
      recurrence: "monthly",
      amount: 10,
      currently_active?: true
    )
  end

  describe "#call" do
    before do
      allow(user).to receive(:commitments).and_return([commitment])
    end

    let(:result) { summary.call }

    it "returns hash with the user's monthly_income" do
      expect(result[:monthly_income]).to eq(5000)
    end

    it "returns hash with the user's savings" do
      expect(result[:savings]).to eq(10000)
    end

    it "returns hash with the user's monthly_commitments_amount" do
      expect(result[:monthly_commitments_amount]).to eq(10)
    end

    it "returns hash with the user's available_cash_flow" do
      expect(result[:available_cash_flow]).to eq(4990)
    end
  end

  describe "#monthly_amount" do
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
            amount: values[:amount]
          )
        end

        it "calculates the correct monthly amount" do
          expect(summary.send(:monthly_amount, commitment)).to eq(values[:expected])
        end
      end
    end
  end

  describe "#monthly_commitments_amount" do
    let(:commitment1) do
      instance_double(
        "Commitment",
        recurrence: "monthly",
        amount: 500,
        currently_active?: true
      )
    end

    let(:commitment2) do
      instance_double(
        "Commitment",
        recurrence: "quarterly",
        amount: 300,
        currently_active?: true
      )
    end

    before do
      allow(user).to receive(:commitments).and_return([commitment1, commitment2])
    end

    context "when there are active commitments" do
      it "sums them all" do
        expect(summary.send(:monthly_commitments_amount)).to eq(600)
      end
    end

    context "when there are inactive commitments" do
      before do
        allow(commitment2).to receive(:currently_active?).and_return(false)
      end

      it "excludes them from the sum" do
        expect(summary.send(:monthly_commitments_amount)).to eq(500)
      end
    end

    context "when there are no commitments" do
      before do
        allow(user).to receive(:commitments).and_return([])
      end

      it "returns zero" do
        expect(summary.send(:monthly_commitments_amount)).to eq(0)
      end
    end
  end

  describe "#available_cash_flow" do
    before do
      allow(user).to receive(:commitments).and_return([commitment])
    end

    context "when monthly_income is present" do
      it "calculates available cash flow as income minus commitments" do
        expect(summary.send(:available_cash_flow)).to eq(4990)
      end
    end

    context "when monthly_income is nil" do
      before do
        allow(user).to receive(:monthly_income).and_return(nil)
      end

      it "returns nil" do
        expect(summary.send(:available_cash_flow)).to be_nil
      end
    end

    context "when there are no commitments" do
      before { allow(user).to receive(:commitments).and_return([]) }

      it "returns full income" do
        expect(summary.send(:available_cash_flow)).to eq(5000)
      end
    end
  end

  describe "#active_commitments" do
    context "when there are active and inactive commitments" do
      let(:commitment1) { instance_double("Commitment", currently_active?: true) }
      let(:commitment2) { instance_double("Commitment", currently_active?: false) }
      let(:commitment3) { instance_double("Commitment", currently_active?: true) }

      before do
        allow(user).to receive(:commitments).and_return([commitment1, commitment2, commitment3])
      end

      it "returns only active commitments" do
        expect(summary.send(:active_commitments)).to eq([commitment1, commitment3])
      end
    end

    context "when there are no commitments" do
      before { allow(user).to receive(:commitments).and_return([]) }

      it "returns empty array" do
        expect(summary.send(:active_commitments)).to eq([])
      end
    end
  end
end
