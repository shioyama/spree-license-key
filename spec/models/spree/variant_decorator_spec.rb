require 'spec_helper'

describe Spree::Variant do
  describe '#valid?' do
    let(:variant) { build :variant }
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
end
