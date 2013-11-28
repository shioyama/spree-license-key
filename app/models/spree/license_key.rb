module Spree
  class LicenseKey < ActiveRecord::Base
    belongs_to :inventory_unit, :class_name => "Spree::InventoryUnit"
    belongs_to :variant, :class_name => "Spree::Variant"
    belongs_to :license_key_type, :class_name => "Spree::LicenseKeyType"

    attr_accessible :license_key, :inventory_unit_id, :variant_id

    scope :available, where(inventory_unit_id: nil)
    scope :used, where('inventory_unit_id IS NOT NULL')

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
      key_count = self.where(:variant_id => inventory_unit.variant.id, :inventory_unit_id => nil, :license_key_type_id => license_key_type.try(:id)).order('id asc').limit(1).update_all(inventory_unit_id: inventory_unit.id)
      if key_count == 0
        raise LicenseKey::InsufficientLicenseKeys, "Variant: #{inventory_unit.variant.to_param}, License Key Type: #{license_key_type.try(:id)}"
      end
      self.where(inventory_unit_id: inventory_unit.id).order('id desc').first
    end
  end
end
