Spree::Order.class_eval do
  # from spree_core
  def create_shipment!
    shipping_method(true)
    if shipment.present?
      shipment.update_attributes!(:shipping_method => shipping_method)
    else
      inventory_units.electronically_delivered.each do |inventory_unit|
        create_shipment_for_inventory_units! [inventory_unit], shipping_method
      end
      create_shipment_for_inventory_units! inventory_units.physically_delivered, shipping_method
    end
  end

  private
    def create_shipment_for_inventory_units!(units, method)
      self.shipments << Spree::Shipment.create!(
        {
          :order => self,
          :shipping_method => method,
          :address => self.ship_address,
          :inventory_units => units
        }, :without_protection => true)
    end
end
