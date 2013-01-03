require 'spec_helper'

describe Spree::ShipmentObserver do
  describe '.after_transition' do
    let(:observer) { Spree::ShipmentObserver.instance }
    let(:shipment) { build_stubbed :shipment }
    let(:transition) { double(StateMachine::Transition) }

    context "when transition is to shipped" do
      before { transition.stub(:to) { "shipped" } }
      context "when shipment is electronic" do
        before { shipment.stub(:electronic?) { true } }

        it 'delivers the electronic item' do
          shipment.should_receive(:electronic_delivery!).once
          observer.after_transition(shipment, transition)
        end
      end
    end
  end
end
