require "spec_helper"

describe Spree::InventoryUnit do

  describe ".increase" do
    context "variant is electronic" do
      let(:order) { create :order }
      let(:physical_variant) { create :variant }
      let(:electronic_variant) { create :electronic_variant }
      let(:line_item) { create :line_item, variant: electronic_variant, order: order }
      let!(:electronic_shipping_method) { create :shipping_method, name: Spree::ShippingMethod::electronic_delivery_name }
      let!(:physical_shipment) { create :shipment, order: order }
      before { order.reload }

      context "electronic shipment exists on order" do
        let!(:electronic_shipment) { create :shipment, order: order, shipping_method: electronic_shipping_method }
        it "creates new inventory units" do
          expect {
            Spree::InventoryUnit.increase(order, electronic_variant, 2)
          }.to change { order.inventory_units.count }.from(0).to(2)
        end

        it "assigns electronic inventory units to electronic shipment" do
          Spree::InventoryUnit.increase(order, electronic_variant, 1)
          expect(order.inventory_units.first.shipment).to eq(electronic_shipment)
        end

        it "assigns physical inventory units to physical shipment" do
          Spree::InventoryUnit.increase(order, physical_variant, 1)
          expect(order.inventory_units.first.shipment).to eq(physical_shipment)
        end
      end

      context "no electronic shipment exists on order" do
        it "creates new electronic shipment" do
          expect {
            Spree::InventoryUnit.increase(order, electronic_variant, 2)
          }.to change { order.shipments.count }.from(1).to(2)
        end

        it "assigns inventory unit to new electronic shipment" do
          Spree::InventoryUnit.increase(order, electronic_variant, 2)
          shipment = order.inventory_units.first.shipment
          expect(shipment).to be_electronic
        end
      end

      context "when calls couple times" do
        it "creates related elctronic shipment couple inventory units" do
          2.times { Spree::InventoryUnit.increase(order, electronic_variant, 1) }

          expect(order.shipments.electronic.first.inventory_units.count).to be(2)
        end
      end
    end

    # tests from spree-core, with minor modification to mocks
    context "variant is physical" do
      let(:variant) { mock_model(Spree::Variant, on_hand: 95, on_demand: false, electronic_delivery?: false) }
      let(:line_item) { mock_model(Spree::LineItem, variant: variant, quantity: 5) }
      let(:order) { mock_model(Spree::Order, line_items: [line_item], inventory_units: [], shipments: mock("shipments"), completed?: true) }
      after(:all) { Spree::Config.clear_preferences }
      context "when :track_inventory_levels is true" do
        before do
          Spree::Config.set track_inventory_levels: true
          Spree::InventoryUnit.stub(:create_units)
        end

        it "should decrement count_on_hand" do
          variant.should_receive(:decrement!).with(:count_on_hand, 5)
          Spree::InventoryUnit.increase(order, variant, 5)
        end

      end

      context "when :track_inventory_levels is false" do
        before do
          Spree::Config.set track_inventory_levels: false
          Spree::InventoryUnit.stub(:create_units)
        end

        it "should decrement count_on_hand" do
          variant.should_not_receive(:decrement!)
          Spree::InventoryUnit.increase(order, variant, 5)
        end

      end

      context "when on_demand is true" do
        before do
          variant.stub(:on_demand).and_return(true)
          Spree::InventoryUnit.stub(:create_units)
        end

        it "should decrement count_on_hand" do
          variant.should_not_receive(:decrement!)
          Spree::InventoryUnit.increase(order, variant, 5)
        end

      end
    end
  end
end
