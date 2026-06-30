# frozen_string_literal: true

require "rails_helper"

RSpec.describe BreakdownSerializer do
  subject(:serializer) { described_class.new(breakdown_data) }

  let(:result) { serializer.serialize }
  let(:obligation) { BigDecimal("800.00") }
  let(:debt) { BigDecimal("100.00") }
  let(:service) { BigDecimal("21.00") }
  let(:investment) { BigDecimal("250.00") }

  let(:breakdown_data) do
    {
      obligation:,
      debt:,
      service:,
      investment:
    }
  end

  describe "#serialize" do
    it "returns a hash with breakdown key" do
      expect(result).to have_key(:breakdown)
    end

    it "transforms all amount values to money format" do
      breakdown_data.each_key do |key|
        expect(result[:breakdown][key]).to be_a(String)
      end
    end

    it "preserves all keys from the original object" do
      expect(result[:breakdown].keys).to eq(breakdown_data.keys)
    end

    it "converts numeric amounts to formatted money strings" do
      expect(result[:breakdown][:obligation]).to eq("800.00")
      expect(result[:breakdown][:debt]).to eq("100.00")
      expect(result[:breakdown][:service]).to eq("21.00")
      expect(result[:breakdown][:investment]).to eq("250.00")
    end
  end
end
