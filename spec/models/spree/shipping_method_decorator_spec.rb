require 'spec_helper'

describe Spree::ShippingMethod do
  describe "changing name" do
    let(:shipping_method) { create :shipping_method, name: name }

    context "when original name is the electronic delivery name" do
      let(:name) { Spree::ShippingMethod::electronic_delivery_name }

      it "is not valid" do
        shipping_method.name = "Something Else"
        shipping_method.should_not be_valid
      end
    end

    context "when the original name is not the electronic delivery name" do
      let(:name) { "Normal Name" }

      it "is valid" do
        shipping_method.name = "Something Else"
        shipping_method.should be_valid
      end
    end
  end

  describe '#electronic' do
    context "when the electronic delivery method exists" do
      let!(:shipping_method) { create :shipping_method, name: name }
      let(:name) { Spree::ShippingMethod::electronic_delivery_name }

      it "returns that shipping_method" do
        Spree::ShippingMethod.electronic.should == shipping_method
      end
    end

    context "when the electronic delivery method doesn't exist" do
      it "raises an error" do
        expect { Spree::ShippingMethod.electronic }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
