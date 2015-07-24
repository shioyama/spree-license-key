require 'spec_helper'

describe Spree::LicenseKey do
  let(:inventory_unit) { create :inventory_unit }
  let!(:available_license_key) { create :license_key }
  let!(:used_license_key) { create :license_key, inventory_unit: inventory_unit }
  let!(:voided_license_key) { create :license_key, void: true }

  describe '.available' do
    it 'returns license keys which do not have inventory units' do
      Spree::LicenseKey.available.all.should == [ available_license_key ]
      expect(available_license_key.available?).to eq true
      expect(used_license_key.available?).to      eq false
      expect(voided_license_key.available?).to    eq false
    end
  end

  describe '.used' do
    it 'returns license keys which have inventory units' do
      Spree::LicenseKey.used.all.should == [ used_license_key ]
      expect(available_license_key.used?).to eq false
      expect(used_license_key.used?).to      eq true
      expect(voided_license_key.used?).to    eq false
    end
  end

  describe '.void' do
    it 'returns license keys which have are voided' do
      Spree::LicenseKey.void.all.should == [ voided_license_key ]
    end
  end
end
