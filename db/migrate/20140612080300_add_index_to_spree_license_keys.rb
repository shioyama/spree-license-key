class AddIndexToSpreeLicenseKeys < ActiveRecord::Migration
  def change
    add_index :spree_license_keys, :license_key_type_id
    add_index :spree_license_keys, :inventory_unit_id
  end
end
