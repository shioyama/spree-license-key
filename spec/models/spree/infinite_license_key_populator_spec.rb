require 'spec_helper'

describe Spree::InfiniteLicenseKeyPopulator do
  describe "#on_hand" do
    let(:populator) { described_class.new(stub_model(Spree::Variant)) }
    it "always returns infinity" do
      expect(populator.on_hand).to eq(Float::INFINITY)
    end
  end
end
