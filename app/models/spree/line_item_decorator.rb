Spree::LineItem.class_eval do
  scope :electronically_delivered, joins(:variant).where('spree_variants.electronic_delivery_keys IS NOT NULL').readonly(false)
  scope :physically_delivered, joins(:variant).where('spree_variants.electronic_delivery_keys IS NULL').readonly(false)
end
