require 'spec_helper'

describe Spree::DefaultLicenseKeyPopulator do
  describe '.get_available_keys!' do
    let(:inventory_unit) { build_stubbed :inventory_unit, variant: variant }
    let(:variant) { nil }
    let(:quantity) { 2 }

    shared_examples_for "license key populator" do
      context "no keys available" do
        it "returns false" do
          Spree::DefaultLicenseKeyPopulator.get_available_keys(inventory_unit, quantity, license_key_type).should == false
        end
      end

      context "keys available" do
        let(:variant) { create :variant }
        let!(:license_keys) { quantity.times.map { create(:license_key, variant: variant, license_key_type: license_key_type) } }

        it "returns license keys with this type" do
          Spree::DefaultLicenseKeyPopulator.get_available_keys(inventory_unit, quantity, license_key_type).should == license_keys
        end

        it "only returns license keys with this type" do
          other_license_key_type = create :license_key_type
          other_license_keys = quantity.times.map { create :license_key, variant: variant, license_key_type: other_license_key_type }
          Spree::DefaultLicenseKeyPopulator.get_available_keys(inventory_unit, quantity, other_license_key_type).should == other_license_keys
        end

        it "only returns license keys without inventory ids" do
          license_keys.each { |key| key.update_attributes!(inventory_unit_id: inventory_unit.id) }
          other_license_keys = quantity.times.map { create :license_key, variant: variant, license_key_type: license_key_type }
          Spree::DefaultLicenseKeyPopulator.get_available_keys(inventory_unit, quantity, license_key_type).should == other_license_keys
        end

        it "only returns license keys that are not void" do
          license_keys.each { |key| key.update_attributes!(void: true) }
          other_license_keys = quantity.times.map { create :license_key, variant: variant, license_key_type: license_key_type }
          Spree::DefaultLicenseKeyPopulator.get_available_keys(inventory_unit, quantity, license_key_type).should == other_license_keys
        end
      end
    end

    context "nil license key type" do
      let(:license_key_type) { nil }
      it_behaves_like "license key populator"
    end

    context "license key type defined" do
      let(:license_key_type) { create(:license_key_type) }
      it_behaves_like "license key populator"
    end
  end
end
