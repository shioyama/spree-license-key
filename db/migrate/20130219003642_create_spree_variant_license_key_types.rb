class CreateSpreeVariantLicenseKeyTypes < ActiveRecord::Migration
  def change
    create_table :spree_variant_license_key_types do |t|
      t.integer :variant_id, :index => true
      t.integer :license_key_type_id, :index => true
    end
  end
end
