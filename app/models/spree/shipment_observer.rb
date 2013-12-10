class Spree::ShipmentObserver < ActiveRecord::Observer
  def before_transition(shipment, transition)
    if transition.to == "shipped" && shipment.electronic?
      shipment.electronic_delivery!
    end
  end
end
