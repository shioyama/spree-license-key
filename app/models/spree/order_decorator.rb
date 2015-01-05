Spree::Order.class_eval do
  include ActiveSupport::Callbacks

  after_update :destroy_empty_shipments!

  def electronic_shipments
    shipments.electronic
  end

  def physical_shipments
    shipments.physical
  end

  def create_shipment_with_electronic_delivery!
    create_shipment_without_electronic_delivery!

    # re-assign electronic inventory units to an electronic shipment
    if line_items.electronically_delivered.any?
      electronic_shipment = shipments.electronic.first_or_create!
      electronic_shipment.inventory_units = inventory_units.electronically_delivered
    end

    destroy_empty_shipments!
  end
  alias_method_chain :create_shipment!, :electronic_delivery

  def after_finalize!
    electronic_shipments.each do |shipment|
      shipment.delay.asynchronous_ship! if shipment.can_ship?
    end
  end

  private

  def destroy_empty_shipments!
    # destroy any physical shipments without inventory units
    if line_items.physically_delivered.empty? && physical_shipments.any?
      physical_shipments.destroy_all
    end

    # destroy any electronic shipments without inventory units
    if line_items.electronically_delivered.empty? && electronic_shipments.any?
      electronic_shipments.destroy_all
    end
  end
end
