class AddActivatedOnToSpreeLicenseKeys < ActiveRecord::Migration
  def change
    add_column :spree_license_keys, :activated_on, :datetime
  end
end
