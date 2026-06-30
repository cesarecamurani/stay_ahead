# frozen_string_literal: true

require "rails_helper"

RSpec.describe SummarySerializer do
  subject(:serializer) { described_class.new(summary_data) }

  let(:result) { serializer.serialize }
  let(:monthly_income) { BigDecimal("5000.00") }
  let(:savings) { BigDecimal("15000.00") }
  let(:monthly_commitments_amount) { BigDecimal("2000.00") }
  let(:available_cash_flow) { BigDecimal("3000.00") }
  let(:savings_runway_months) { BigDecimal("7.5") }

  let(:summary_data) do
    {
      monthly_income:,
      savings:,
      monthly_commitments_amount:,
      available_cash_flow:,
      savings_runway_months:
    }
  end

  describe "#serialize" do
    context "with valid summary data" do
      it "returns serialized summary hash" do
        expect(result).to have_key(:summary)
      end

      it "formats monthly_income as money" do
        expect(result[:summary][:monthly_income]).to eq("5000.00")
      end

      it "formats savings as money" do
        expect(result[:summary][:savings]).to eq("15000.00")
      end

      it "formats monthly_commitments_amount as money" do
        expect(result[:summary][:monthly_commitments_amount]).to eq("2000.00")
      end

      it "formats available_cash_flow as money" do
        expect(result[:summary][:available_cash_flow]).to eq("3000.00")
      end

      it "formats savings_runway_months as decimal" do
        expect(result[:summary][:savings_runway_months]).to eq(7.5)
      end
    end

    summary_fields = %i[
      monthly_income
      savings
      monthly_commitments_amount
      available_cash_flow
      savings_runway_months
    ]

    (summary_fields - [:savings_runway_months]).each do |field|
      context "when #{field} is zero" do
        let(field) { BigDecimal("0.00") }

        it "returns zero for #{field}" do
          expect(result[:summary][field]).to eq("0.00")
        end
      end
    end

    context "when savings_runway_months is zero" do
      let(:savings_runway_months) { BigDecimal("0.00") }

      it "returns zero for savings_runway_months" do
        expect(result[:summary][:savings_runway_months]).to eq(0.0)
      end
    end

    summary_fields.each do |field|
      context "when #{field} is nil" do
        let(field) { nil }

        it "returns nil for #{field}" do
          expect(result[:summary][field]).to be_nil
        end
      end
    end
  end
end
