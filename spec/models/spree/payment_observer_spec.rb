require 'spec_helper'

describe Spree::PaymentObserver do
  describe '.after_transition' do
    let(:observer) { Spree::PaymentObserver.instance }
    let(:payment) { build_stubbed :payment, :order => order}
    let(:order) { build_stubbed :order }
    let(:transition) { double StateMachine::Transition }
    let(:shipment) { double Spree::Shipment }

    context "when transition is to shipped" do
      before do
        transition.stub(:event) { :complete }
        order.stub(:electronic_shipments) { [shipment] }
      end

      it 'delivers the electronic item' do
        shipment.should_receive(:ship!).once
        observer.after_transition(payment, transition)
      end
    end
  end
end
