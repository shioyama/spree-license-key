require 'spec_helper'

describe Spree::OrderPopulator do
  let(:order) { create :order }
  let(:currency) { 'USD' }
  let(:line_items) { order.line_items }

  describe '.populate' do
    let(:order_populator) { Spree::OrderPopulator.new(order, currency) }
    let!(:variant) { create :variant }
    context 'with no :variants or :products keys' do
      it 'returns true if valid' do
        order_populator.populate({}).should == true
      end
    end
    # default behaviour
    context 'without options' do
      context 'with single variant/quantity pairing' do
        before { order_populator.populate(variants: { variant.id.to_s => 5 }) }
        describe 'line item' do
          subject { line_items.first }
          its(:variant_id) { should == variant.id }
          its(:quantity) { should == 5 }
        end
      end
    end
    # added options
    context 'with options' do
      before do
        order_populator.populate(variants: { variant.id.to_s => options })
      end

      context 'no quantity in options' do
        let(:options) { { "license_key" => "abcde" } }
        subject { order }
        it { should have(1).line_item }

        describe 'line item' do
          subject { line_items.first }
          its(:variant_id) { should == variant.id }
          its(:license_key) { should == "abcde" }
          its(:quantity) { should == 1 }
        end
      end

      context 'quantity in options' do
        let(:options) { { "license_key" => "abcde", "quantity" => 3 } }
        subject { order }
        it { should have(1).line_item }

        it "assigns quantity to line item" do
          line_items.first.quantity.should == 3
        end
      end
    end
  end
end
