class Spree::PaymentObserver < ActiveRecord::Observer
  def after_transition(payment, transition)
    if transition.event == :complete
      payment.order.electronic_shipments.each do |shipment|
        shipment.ship! if shipment.can_ship?
      end
    end
  end
end
