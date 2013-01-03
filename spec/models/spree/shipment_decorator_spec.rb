require 'spec_helper'

describe Spree::Shipment do
  let(:shipment) { Spree::Shipment.new }

  describe '.electronic?' do
    before { shipment.shipping_method = shipping_method }
    subject { shipment.electronic? }
    let(:shipping_method) { build_stubbed :shipping_method, name: Spree::ShippingMethod.electronic_delivery_name }

    context "when shipping method is the electronic shipping method" do
      before { Spree::ShippingMethod.stub(:electronic) { shipping_method } }

      it { should be_true }
    end

    context "when shipping method is not the electronic shipping method" do
      before { Spree::ShippingMethod.stub(:electronic) { build :shipping_method } }

      it { should be_false }
    end
  end

  describe '.electronic_delivery!' do
    let(:inventory_unit) { create :inventory_unit }
    let(:license_key) { create :license_key }

    before do
      shipment.inventory_units = [inventory_unit]
      shipment.order = build_stubbed(:order)
      Spree::LicenseKey.should_receive(:next!) do
        inventory_unit.stub(:license_key) { license_key }
        license_key
      end
    end

    it 'sends an email' do
      Mail::Message.any_instance.should_receive(:deliver)
      shipment.electronic_delivery!
    end
  end
end
