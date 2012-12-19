require 'spec_helper'

describe Spree::LicenseKey do
  describe '#next' do
    let(:user) { build_stubbed :user }
    let!(:license_key) { create :license_key, :user => license_user }
    let(:license_user) { nil }

    shared_examples_for "insufficient_license_keys" do
      it "throws an insufficient license keys exception" do
        expect { Spree::LicenseKey.next!(variant, user) }.to raise_error(Spree::LicenseKey::InsufficientLicenseKeys)
      end
    end

    context "when there are keys" do
      let(:variant) { license_key.variant }

      context "when the key is not claimed" do
        it "gets a license key" do
          key = Spree::LicenseKey.next!(variant, user)
          key.should == license_key
        end
      end

      context "when the key is claimed" do
        let(:license_user) { build_stubbed :user }

        it_behaves_like "insufficient_license_keys"
      end
    end

    context "when there are no license keys" do
      let(:variant) { build_stubbed :variant }

      it_behaves_like "insufficient_license_keys"
    end
  end
end
