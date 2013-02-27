module Spree
  class LicenseKey < ActiveRecord::Base
    belongs_to :inventory_unit, :class_name => "Spree::InventoryUnit"
    belongs_to :variant, :class_name => "Spree::Variant"
    belongs_to :license_key_type, :class_name => "Spree::LicenseKeyType"

    attr_accessible :license_key, :inventory_unit_id, :variant_id

    scope :available, where(inventory_unit_id: nil)

    def self.assign_license_keys!(inventory_unit)
      transaction do
        if inventory_unit.variant.license_key_types.empty?
          [self.get_available_key(inventory_unit)]
        else
          inventory_unit.variant.license_key_types.map do |key_type|
            self.get_available_key(inventory_unit, key_type)
          end
        end
      end
    end

    class InsufficientLicenseKeys < ::StandardError; end

    private

    def self.get_available_key(inventory_unit, license_key_type = nil)
      license_key = self.where(:variant_id => inventory_unit.variant.id, :inventory_unit_id => nil, :license_key_type_id => license_key_type.try(:id)).first
      if license_key.nil?
        raise LicenseKey::InsufficientLicenseKeys, "Variant: #{inventory_unit.variant.to_param}, License Key Type: #{license_key_type.try(:id)}"
      end
      license_key.inventory_unit = inventory_unit
      license_key.save!
      license_key
    end
  end
end
