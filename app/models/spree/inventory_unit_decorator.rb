Spree::InventoryUnit.class_eval do
  scope :electronically_delivered, -> { joins(:variant).where(spree_variants: {electronic_delivery: true}).readonly(false) }
  scope :physically_delivered, -> { joins(:variant).where(spree_variants: {electronic_delivery: false}).readonly(false) }

  has_many :license_keys, class_name: "Spree::LicenseKey", dependent: :nullify

  delegate :electronic_delivery_keys, :license_key_populator, :to => :variant

  def populate_license_keys
    license_key_populator.populate(self, electronic_delivery_keys)
  end
end
