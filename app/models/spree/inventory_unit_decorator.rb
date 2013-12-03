Spree::InventoryUnit.class_eval do
  scope :electronically_delivered, -> { joins(:variant).where(spree_variants: {electronic_delivery: true}).readonly(false) }
  scope :physically_delivered, -> { joins(:variant).where(spree_variants: {electronic_delivery: false}).readonly(false) }

  has_many :license_keys, class_name: "Spree::LicenseKey", dependent: :nullify

  delegate :electronic_delivery_keys, :to => :variant
end
