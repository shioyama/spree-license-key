module Spree
  class LicenseKey < ActiveRecord::Base
    belongs_to :inventory_unit, :class_name => "Spree::InventoryUnit"
    belongs_to :variant, :class_name => "Spree::Variant"
    belongs_to :license_key_type, :class_name => "Spree::LicenseKeyType"

    attr_accessible :license_key, :inventory_unit_id, :variant_id

    def self.assign_license_keys!(inventory_unit)
      transaction do
        license_key = self.where(:variant_id => inventory_unit.variant.id, :inventory_unit_id => nil).first
        if license_key.nil?
          raise LicenseKey::InsufficientLicenseKeys, inventory_unit.variant.inspect
        end
        license_key.inventory_unit = inventory_unit
        license_key.save!
        license_key
      end
    end

    class InsufficientLicenseKeys < ::StandardError; end
  end
end
