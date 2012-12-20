class AddElectronicDeliveryToSpreeVariants < ActiveRecord::Migration
  def change
    add_column :spree_variants, :electronic_delivery, :boolean, :null => false, :default => false
  end
end
