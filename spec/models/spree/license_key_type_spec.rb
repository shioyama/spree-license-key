require 'spec_helper'

describe Spree::LicenseKeyType do
  describe '.available' do
    let(:license_key_type) { create :license_key_type }
    let!(:license_key) { create :license_key, license_key_type: license_key_type }

    it "returns license keys with this type" do
      create :license_key, license_key_type: create(:license_key_type)
      license_key_type.available.should == [ license_key ]
    end
  end
end
