Spree::InventoryUnit.class_eval do
  scope :electronically_delivered, joins(:variant).where('spree_variants.electronic_delivery_keys IS NOT NULL').readonly(false)
  scope :physically_delivered, joins(:variant).where('spree_variants.electronic_delivery_keys IS NULL').readonly(false)

  has_many :license_keys, class_name: "Spree::LicenseKey"

  delegate :electronic_delivery_keys, :to => :variant
end
