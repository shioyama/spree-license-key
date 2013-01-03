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
end
