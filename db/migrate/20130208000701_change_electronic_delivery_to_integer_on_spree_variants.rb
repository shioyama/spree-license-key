class ChangeElectronicDeliveryToIntegerOnSpreeVariants < ActiveRecord::Migration
  def up
    add_column :spree_variants, :electronic_delivery_keys, :integer
    Spree::Variant.all.each do |v|
      if v[:electronic_delivery]
        v[:electronic_delivery_keys] = 1
        v.save!
      end
    end
    remove_column :spree_variants, :electronic_delivery
  end

  def down
    add_column :spree_variants, :electronic_delivery, :boolean
    Spree::Variant.all.each do |v|
      if v[:electronic_delivery_keys] && v[:electronic_delivery_keys] > 0
        v[:electronic_delivery] = true
        v.save!
      end
    end
    remove_column :spree_variants, :electronic_delivery_keys
  end
end
