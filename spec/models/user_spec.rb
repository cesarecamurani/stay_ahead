# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  subject(:user) { build(:user, currency:) }

  let(:currency) { "EUR" }

  describe "validations" do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_numericality_of(:monthly_income).is_greater_than_or_equal_to(0).allow_nil }
    it { is_expected.to validate_numericality_of(:savings).is_greater_than_or_equal_to(0).allow_nil }
  end

  describe "#valid_currency?" do
    context "when currency is blank" do
      let(:currency) { nil }

      before { user.validate }

      it "does not add an error" do
        expect(user.errors[:currency]).to be_empty
      end
    end

    context "when currency is valid" do
      before { user.validate }

      it "does not add an error" do
        expect(user.errors[:currency]).to be_empty
      end

      it "accepts other valid currencies" do
        expect(user.errors[:currency]).to be_empty
      end
    end

    context "when currency is invalid" do
      let(:currency) { "XXX" }

      before { user.validate }

      it "adds an error" do
        expect(user.errors[:currency]).to include("is not a valid currency")
      end

      it "marks the user as invalid" do
        expect(user).to be_invalid
      end
    end
  end
end
