require 'spec_helper'

describe Spree::LicenseKey do
  describe '#assign_license_keys!' do
    let(:inventory_unit) { build_stubbed :inventory_unit }
    let!(:license_key) { create :license_key, :inventory_unit => license_inventory_unit }
    let(:license_inventory_unit) { nil }

    shared_examples_for "insufficient_license_keys" do
      it "throws an insufficient license keys exception" do
        expect { Spree::LicenseKey.assign_license_keys!(inventory_unit) }.to raise_error(Spree::LicenseKey::InsufficientLicenseKeys)
      end
    end

    context "when license_key_type not specified" do
      context "when there are keys" do
        let(:inventory_unit) { build_stubbed :inventory_unit, :variant => variant }
        let(:variant) { license_key.variant }

        context "when the key is not claimed" do
          it "gets a license key" do
            keys = Spree::LicenseKey.assign_license_keys!(inventory_unit)
            keys.should == [license_key]
          end
        end

        context "when the key is claimed" do
          let(:license_inventory_unit) { build_stubbed :inventory_unit }

          it_behaves_like "insufficient_license_keys"
        end
      end

      context "when there are no license keys" do
        let(:variant) { build_stubbed :variant }

        it_behaves_like "insufficient_license_keys"
      end
    end

    context "with multiple license key types" do
      context "when there are keys" do
        let(:inventory_unit) { build_stubbed :inventory_unit, :variant => variant }
        let(:license_key_types) { [create(:license_key_type), create(:license_key_type)]}
        let!(:license_keys) do
          [
            create(:license_key, :variant => variant, :license_key_type => license_key_types.first),
            create(:license_key, :variant => variant, :license_key_type => license_key_types.last)
          ]
        end
        let(:variant) { license_key.variant }

        before do
          variant.license_key_types = license_key_types
        end

        it 'assigns both license keys' do
          keys = Spree::LicenseKey.assign_license_keys!(inventory_unit)
          keys.should == license_keys
        end
      end
    end
  end
end
