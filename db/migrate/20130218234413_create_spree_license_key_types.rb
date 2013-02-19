class CreateSpreeLicenseKeyTypes < ActiveRecord::Migration
  def change
    create_table :spree_license_key_types do |t|
      t.string :slug

      t.timestamps
    end
  end
end
