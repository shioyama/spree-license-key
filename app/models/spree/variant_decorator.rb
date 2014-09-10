Spree::Variant.class_eval do
  has_many :license_keys, class_name: 'Spree::LicenseKey'
  has_and_belongs_to_many :license_key_types, :join_table => :spree_variant_license_key_types, :class_name => "Spree::LicenseKeyType"

  attr_accessible :electronic_delivery_keys, :electronic_delivery

  validate :electronic_delivery_set

  def license_key_populator
    populator_type.present? ? populator_type.try(:constantize) : Spree::DefaultLicenseKeyPopulator
  end

  private
  def electronic_delivery_set
    if self.electronic_delivery_keys && self.electronic_delivery_keys > 0 && !self.electronic_delivery?
      errors.add(:electronic_delivery, I18n.t('spree.variant.electronic_delivery_setting_error'))
    end
  end
end
