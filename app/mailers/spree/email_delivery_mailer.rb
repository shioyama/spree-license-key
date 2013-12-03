class Spree::EmailDeliveryMailer < ActionMailer::Base
  def electronic_delivery_email(shipment)
    @inventory_units = shipment.inventory_units
    mail :to => shipment.order.user.email
  end
end
