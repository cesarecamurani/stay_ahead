# frozen_string_literal: true

require "rails_helper"

RSpec.describe Commitment, type: :model do
  subject { build(:commitment) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:category) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:recurrence) }
    it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
    it { is_expected.to validate_numericality_of(:interest_rate).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:duration_months).is_greater_than(0).only_integer }
  end
end
