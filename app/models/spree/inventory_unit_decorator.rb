Spree::InventoryUnit.class_eval do
  scope :electronically_delivered, -> { joins(:variant).where(spree_variants: {electronic_delivery: true}).readonly(false) }
  scope :physically_delivered, -> { joins(:variant).where(spree_variants: {electronic_delivery: false}).readonly(false) }

  has_many :license_keys, class_name: "Spree::LicenseKey", dependent: :nullify

  delegate :electronic_delivery_keys, :license_key_populator, :to => :variant

  def populate_license_keys
    license_key_populator.populate(self, electronic_delivery_keys)
  end

  def has_electronic_delivery_keys?
    electronic_delivery_keys && electronic_delivery_keys > 0
  end

  class << self
    def increase_with_electronic_shipments(order, variant, quantity)
      if variant.electronic_delivery?
        # Simplified from spree-core: no tracking levels and always
        # create inventory units for electronic variants
        create_electronic_units(order, variant, quantity)
      else
        increase_without_electronic_shipments(order, variant, quantity)
      end
    end
    alias_method_chain :increase, :electronic_shipments

    private

    # paraphrased from spree-core (create_units), with changes to assign
    # inventory units to electronic shipment
    def create_electronic_units(order, variant, quantity)
      shipment = order.shipments.electronic.first

      quantity.times do
        order.inventory_units.create(
          { variant: variant, state: "sold", shipment: shipment },
          without_protection: true)
      end
    end
  end
end
