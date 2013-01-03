class SwitchLicenseKeyFromUsersToInventoryUnits < ActiveRecord::Migration
  def up
    remove_index :spree_license_keys, [:variant_id, :license_key]
    add_column :spree_license_keys, :inventory_unit_id, :integer
    remove_column :spree_license_keys, :user_id
    add_index :spree_license_keys, [:variant_id, :license_key], :unique => true, :name => 'index_variant_license_key_unique'
  end

  def down
    remove_index :spree_license_keys, :name => :index_variant_license_key_unique
    remove_column :spree_license_keys, :inventory_unit_id
    add_column :spree_license_keys, :user_id, :integer
    add_index :spree_license_keys, [:variant_id, :license_key], :unique => true
  end
end
