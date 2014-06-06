Spree::LineItem.class_eval do
  scope :electronically_delivered, -> { joins(:variant).where(spree_variants: {electronic_delivery: true}).readonly(false) }
  scope :physically_delivered, -> { joins(:variant).where(spree_variants: {electronic_delivery: false}).readonly(false) }

  # Assigns license key to line item, for use in e.g. renewals or upgrades,
  # where we need to keep track on what license key we are renewing/upgrading from.
  def assign_options!(options)
    self.license_key = options["license_key"]
    save!
  end
end
