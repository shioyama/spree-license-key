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
    it 'works' do
      expect { order.create_shipment! }.to change{order.shipments.count}.from(0).to(3)
    end
  end
end
