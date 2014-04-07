module Spree
  class DefaultLicenseKeyPopulator < LicenseKeyPopulator

    def self.get_available_keys(inventory_unit, license_key_type, quantity)
      return false unless count_available(inventory_unit, license_key_type) >= quantity
      LicenseKey.where(
        :variant_id => inventory_unit.variant.id,
        :inventory_unit_id => nil,
        :license_key_type_id => license_key_type.try(:id)
      ).order('id asc').limit(quantity)
    end

    private

    def self.count_available(inventory_unit, license_key_type)
      relation = license_key_type ? license_key_type.available : Spree::LicenseKey.available.where(license_key_type_id: nil)
      relation.where(variant_id: inventory_unit.variant.try(:id)).count
    end
  end
end
