Spree::InventoryUnit.class_eval do
  scope :electronically_delivered, joins(:variant).where(:spree_variants => { :electronic_delivery => true }).readonly(false)
  scope :physically_delivered, joins(:variant).where(:spree_variants => { :electronic_delivery => false }).readonly(false)

  delegate :electronic_delivery, :to => :variant
end
