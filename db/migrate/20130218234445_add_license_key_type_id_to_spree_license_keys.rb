class AddLicenseKeyTypeIdToSpreeLicenseKeys < ActiveRecord::Migration
  def change
    add_column :spree_license_keys, :license_key_type_id, :integer
  end
end
