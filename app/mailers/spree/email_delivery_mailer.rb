class Spree::EmailDeliveryMailer < ActionMailer::Base
  def electronic_delivery_email(shipment)
    @inventory_units = shipment.inventory_units
    mail :to => shipment.order.user.email
  end

  handle_asynchronously :electronic_delivery_email
end
