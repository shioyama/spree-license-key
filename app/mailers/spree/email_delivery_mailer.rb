class Spree::EmailDeliveryMailer < ActionMailer::Base
  def send_license_keys(shipment)
    @inventory_units = shipment.inventory_units
    mail :to => shipment.order.user.email
  end
end
