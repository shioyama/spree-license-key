Spree::Shipment.class_eval do
  scope :electronic, lambda { where(:shipping_method_id => Spree::ShippingMethod.electronic.id) }
  scope :physical, lambda { where('shipping_method_id != ?', Spree::ShippingMethod.electronic.id) }

  def electronic?
    shipping_method.id == Spree::ShippingMethod.electronic.id
  end

  def electronic_delivery!
    inventory_units.each do |inventory_unit|
      if inventory_unit.license_keys.empty? && inventory_unit.electronic_delivery_keys
        inventory_unit.populate_license_keys
        inventory_unit.reload
      end
    end
  end

  # Delayed jobs for asynchronous shipments should silently die if they cannot be shipped,
  # e.g. in case they have been manually shipped since the last attempt.
  def asynchronous_ship!
    ship! if can_ship?
  end

  # Modified from spree_core
  # This function is modified to ensure that inventory_units are only shipped
  # when they can be shipped
  def after_ship
    # Begin modified code
    inventory_units.each do |iu|
      iu.ship! if iu.can_ship?
    end
    # End modified code

    send_shipped_email
    touch :shipped_at
  end

  # Modified from spree_core
  # This will only send the e-mail if it is not electronic
  def send_shipped_email
    if electronic?
      Spree::EmailDeliveryMailer.electronic_delivery_email(self).deliver
    else
      Spree::ShipmentMailer.shipped_email(self).deliver
    end
  end
end
