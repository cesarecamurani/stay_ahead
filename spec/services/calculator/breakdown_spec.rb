# frozen_string_literal: true

require "rails_helper"

RSpec.describe Calculator::Breakdown do
  subject(:breakdown) { described_class.new(user) }

  let(:user) { create(:user) }

  describe "#call" do
    context "when there are active commitments" do
      before do
        create(
          :commitment,
          user:,
          category: :obligation,
          recurrence: :monthly,
          amount: 1200
        )

        create(
          :commitment,
          user:,
          category: :obligation,
          recurrence: :monthly,
          amount: 300
        )

        create(
          :commitment,
          user:,
          category: :service,
          recurrence: :monthly,
          amount: 15
        )
      end

      it "returns all categories" do
        expect(breakdown.call.keys).to match_array(
          %w[obligation debt service investment]
        )
      end

      it "sums monthly amounts by category" do
        expect(breakdown.call).to include(
          "obligation" => BigDecimal("1500"),
          "service" => BigDecimal("15")
        )
      end
    end

    context "when a commitment is inactive" do
      before do
        create(
          :commitment,
          user:,
          category: :debt,
          recurrence: :monthly,
          amount: 500,
          status: :inactive
        )
      end

      it "does not include inactive commitments" do
        expect(breakdown.call["debt"]).to eq(BigDecimal("0"))
      end
    end

    context "when there are no commitments" do
      it "returns all categories with zero amounts" do
        expect(breakdown.call).to eq(
          {
            "obligation" => BigDecimal("0"),
            "debt" => BigDecimal("0"),
            "service" => BigDecimal("0"),
            "investment" => BigDecimal("0")
          }
        )
      end
    end
  end
end
