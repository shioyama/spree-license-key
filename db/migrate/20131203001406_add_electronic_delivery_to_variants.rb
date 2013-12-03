class AddElectronicDeliveryToVariants < ActiveRecord::Migration
  def change
    add_column :spree_variants, :electronic_delivery, :boolean, default: false
  end
end
