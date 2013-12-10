class Spree::OrderObserver < ActiveRecord::Observer
  def after_transition(order, transition)
    if transition.to == "complete" && order.paid?
      order.electronic_shipments.each do |shipment|
        shipment.ship! if shipment.can_ship?
      end
    end
  end
end
