require "spec_helper"

describe Spree::EmailDeliveryMailer do
  let(:license_key) { build_stubbed :license_key }
  let(:inventory_unit) { build_stubbed :inventory_unit, :license_key => license_key }
  let(:shipment) { build_stubbed :shipment, :inventory_units => [inventory_unit] }

  describe '.send_license_keys' do
    subject { Spree::EmailDeliveryMailer.send_license_keys(shipment) }

    it 'renders the subject' do
      subject.subject.should == "License Key Delivery"
    end
  end
end
