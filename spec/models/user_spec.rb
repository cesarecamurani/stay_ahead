# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  subject { build(:user) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_numericality_of(:monthly_income).is_greater_than_or_equal_to(0).allow_nil }
    it { is_expected.to validate_numericality_of(:savings).is_greater_than_or_equal_to(0).allow_nil }
  end
end
