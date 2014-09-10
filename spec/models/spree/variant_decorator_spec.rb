require 'spec_helper'

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
      it { should == Spree::DefaultLicenseKeyPopulator }
    end

    context 'when populator type is nil' do
      before { variant.populator_type = nil }
      it { should == Spree::DefaultLicenseKeyPopulator }
    end

    context 'when populator type is another class' do
      before { variant.populator_type = 'Spree' }
      it { should == Spree }
    end
  end
end
