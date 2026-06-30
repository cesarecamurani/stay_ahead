# frozen_string_literal: true

require "rails_helper"

RSpec.describe BaseSerializer do
  subject(:serializer) { described_class.new(object) }

  let(:object) { double("object") }

  describe "#initialize" do
    it "stores the object in the instance variable" do
      expect(serializer.send(:object)).to eq(object)
    end

    it "accepts any type of object" do
      expect { BaseSerializer.new({}) }.not_to raise_error
      expect { BaseSerializer.new([]) }.not_to raise_error
      expect { BaseSerializer.new(nil) }.not_to raise_error
    end
  end

  describe "#money" do
    it "returns nil when value is nil" do
      expect(serializer.send(:money, nil)).to be_nil
    end

    it "formats positive values to 2 decimal places" do
      expect(serializer.send(:money, 10.5)).to eq("10.50")
      expect(serializer.send(:money, 100)).to eq("100.00")
    end

    it "formats negative values to 2 decimal places" do
      expect(serializer.send(:money, -15.7)).to eq("-15.70")
    end

    it "handles very small values" do
      expect(serializer.send(:money, 0.01)).to eq("0.01")
      expect(serializer.send(:money, 0.001)).to eq("0.00")
    end

    it "handles large values" do
      expect(serializer.send(:money, 1_000_000.99)).to eq("1000000.99")
    end
  end

  describe "#decimal" do
    it "returns nil when value is nil" do
      expect(serializer.send(:decimal, nil)).to be_nil
    end

    it "rounds to default precision of 4" do
      expect(serializer.send(:decimal, 1.123456)).to eq(1.1235)
    end

    it "rounds to custom precision" do
      expect(serializer.send(:decimal, 1.123456, precision: 2)).to eq(1.12)
      expect(serializer.send(:decimal, 1.123456, precision: 3)).to eq(1.123)
    end

    it "handles precision of 0" do
      expect(serializer.send(:decimal, 1.7, precision: 0)).to eq(2.0)
    end

    it "returns a Float" do
      expect(serializer.send(:decimal, 1.234)).to be_a(Float)
    end

    it "handles negative values" do
      expect(serializer.send(:decimal, -1.123456)).to eq(-1.1235)
    end
  end

  describe "#serialize" do
    it "raises NotImplementedError" do
      expect { serializer.send(:serialize) }.to raise_error(NotImplementedError)
    end

    it "includes the class name in the error message" do
      expect { serializer.send(:serialize) }.to raise_error(
        NotImplementedError,
        "BaseSerializer must implement #serialize"
      )
    end
  end
end
