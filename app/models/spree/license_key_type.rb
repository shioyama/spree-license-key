class Spree::LicenseKeyType < ActiveRecord::Base
  attr_accessible :slug

  has_many :license_keys, :class_name => "Spree::LicenseKey"
  has_and_belongs_to_many :variants, :join_table => :spree_variant_license_key_types, :class_name => "Spree::Variant"

  validates :slug, :presence => true

  def available
    Spree::LicenseKey.available.where(license_key_type_id: id)
  end
end
