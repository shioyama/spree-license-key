Spree::Shipment.class_eval do
  scope :electronic, lambda { where(:shipping_method_id => Spree::ShippingMethod.electronic.id) }
  scope :physical, lambda { where('shipping_method_id != ?', Spree::ShippingMethod.electronic.id) }

  def electronic?
    shipping_method.id == Spree::ShippingMethod.electronic.id
  end

  def electronic_delivery!
    inventory_units.each do |inventory_unit|
      unless inventory_unit.license_key
        license_key = Spree::LicenseKey.next!(inventory_unit)
        inventory_unit.reload
      end
    end
    Spree::EmailDeliveryMailer.send_license_keys(self).deliver
  end
end
