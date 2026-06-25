# frozen_string_literal: true

require "rails_helper"

RSpec.describe Commitment, type: :model do
  subject(:commitment) do
    build(
      :commitment,
      start_date:,
      duration_months:,
      status:
    )
  end

  let(:start_date) { Date.current - 1.month }
  let(:duration_months) { 3 }
  let(:status) { :active }

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:category) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:recurrence) }
    it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
    it { is_expected.to validate_numericality_of(:interest_rate).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:duration_months).is_greater_than(0).only_integer }
  end

  describe "#currently_active?" do
    context "when the commitment is active and within the duration" do
      it "returns true" do
        expect(commitment.currently_active?).to be true
      end
    end

    context "when the commitment is inactive" do
      let(:status) { :inactive }

      it "returns false" do
        expect(commitment.currently_active?).to be false
      end
    end

    context "when the commitment has not started yet" do
      let(:start_date) { Date.current + 1.month }

      it "returns false" do
        expect(commitment.currently_active?).to be false
      end
    end

    context "when the commitment has expired" do
      let(:start_date) { Date.current - 4.months }

      it "returns false" do
        expect(commitment.currently_active?).to be false
      end
    end

    context "when the commitment has no duration" do
      let(:duration_months) { nil }

      it "returns true if active and started" do
        expect(commitment.currently_active?).to be true
      end

      it "returns false if inactive" do
        commitment.status = :inactive

        expect(commitment.currently_active?).to be false
      end

      it "returns false if not started yet" do
        commitment.start_date = Date.current + 1.month

        expect(commitment.currently_active?).to be false
      end
    end
  end
end
