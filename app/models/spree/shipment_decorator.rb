Spree::Shipment.class_eval do
  scope :electronic, lambda { where(:shipping_method_id => Spree::ShippingMethod.electronic.id) }
  scope :physical, lambda { where('shipping_method_id != ?', Spree::ShippingMethod.electronic.id) }

  def electronic?
    shipping_method.id == Spree::ShippingMethod.electronic.id
  end

  def electronic_delivery!
    # TODO: Implement
  end
end
