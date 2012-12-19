class CreateSpreeLicenseKeys < ActiveRecord::Migration
  def change
    create_table :spree_license_keys do |t|
      t.integer :variant_id, :null => false
      t.string :license_key, :null => false
      t.integer :user_id

      t.timestamps
    end
    add_index :spree_license_keys, [:variant_id, :license_key], :unique => true
    add_index :spree_license_keys, :user_id
  end
end
