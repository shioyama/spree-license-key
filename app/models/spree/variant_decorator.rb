Spree::Variant.class_eval do
  has_and_belongs_to_many :license_key_types, :join_table => :spree_variant_license_key_types, :class_name => "Spree::LicenseKeyType"
end
