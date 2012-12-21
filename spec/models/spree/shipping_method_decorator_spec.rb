require 'spec_helper'

describe Spree::ShippingMethod do
  let(:shipping_method) { create :shipping_method, name: name }

  describe "changing name" do

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
end
