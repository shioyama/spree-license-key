Spree::ShippingMethod.class_eval do
  ELECTRONIC_DELIVERY_NAME = 'E-mail Delivery'

  validate do
    if (name_changed? && name_was == ELECTRONIC_DELIVERY_NAME)
      errors.add :name, "You're not allowed to modify the magic #{ELECTRONIC_DELIVERY_NAME} name"
    end
  end

  def self.electronic_delivery_name
    ELECTRONIC_DELIVERY_NAME
  end

  def self.electronic
    self.where(:name => ELECTRONIC_DELIVERY_NAME).first!
  end
end
