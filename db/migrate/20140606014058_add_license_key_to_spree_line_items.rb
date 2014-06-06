class AddLicenseKeyToSpreeLineItems < ActiveRecord::Migration
  def change
    add_column :spree_line_items, :license_key, :string
  end
end
