require 'spec_helper'

describe Spree::Order do
  let(:shipping_method) { create :shipping_method }
  let(:order) { create :order, :shipping_method => shipping_method }
  let(:electronic_variant) { create :variant, :electronic_delivery => true }
  let(:physical_variant) { create :variant, :electronic_delivery => false }

  before do
    [electronic_variant, physical_variant].each do |variant|
      2.times do
        create :inventory_unit, :variant => variant, :order => order
      end
    end
  end

  describe '.create_shipment!' do
    context "when shipment present" do
      let(:shipment) { mock_model Spree::Shipment }
      before { order.stub(:shipment) { shipment } }

      it "updates shipment attributes" do
        shipment.should_receive(:update_attributes!).once
        order.create_shipment!
      end
    end

    context "when shipment not present" do
      it 'works' do
        expect { order.create_shipment! }.to change{order.shipments.count}.from(0).to(3)
      end
    end
  end
end
