class Spree::ShipmentObserver < ActiveRecord::Observer
  def after_transition(shipment, transition)
    if transition.to == "shipped" && shipment.electronic?
      shipment.electronic_delivery!
    end
  end
end
