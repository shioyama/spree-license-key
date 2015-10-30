require 'spec_helper'

class MyPopulator < Spree::LicenseKeyPopulator; end

describe Spree::Variant do
  let(:variant) { build :variant }

  describe '#valid?' do
    subject { variant.valid? }
    context 'when electronic_delivery_keys > 0' do
      before do
        variant.electronic_delivery_keys = 1
      end
      context 'and electronic_delivery is false' do
        before do
          variant.electronic_delivery = false
        end
        it { should_not be }
      end
      context 'and electronic_delivery is true' do
        before do
          variant.electronic_delivery = true
        end
        it { should be }
      end
    end
  end

  describe 'license_key_populator' do
    let(:variant) { build :variant }
    subject { variant.license_key_populator }

    context 'when populator type is blank' do
      before { variant.populator_type = '' }
      it { should be_a(Spree::DefaultLicenseKeyPopulator) }
      its(:variant) { should == variant }
    end

    context 'when populator type is nil' do
      before { variant.populator_type = nil }
      it { should be_a(Spree::DefaultLicenseKeyPopulator) }
      its(:variant) { should == variant }
    end

    context 'when populator type is another class' do
      before { variant.populator_type = 'MyPopulator' }
      it { should be_a(MyPopulator) }
      its(:variant) { should == variant }
    end
  end

  describe 'on_hand' do
    let(:variant) do
      build_stubbed :variant, on_hand: 5, electronic_delivery: electronic_delivery
    end

    context 'physical delivery' do
      let(:electronic_delivery) { false }
      it 'returns number on hand' do
        expect(variant.on_hand).to eq(5)
      end
    end

    context 'electronic delivery' do
      let(:electronic_delivery) { true }
      before do
        variant.stub(:license_key_populator) do
          double("license key populator", on_hand: 10)
        end
      end

      it 'returns number on hand according to populator' do
        expect(variant.on_hand).to eq(10)
      end
    end
  end
end
