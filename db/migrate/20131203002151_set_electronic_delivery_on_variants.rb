class SetElectronicDeliveryOnVariants < ActiveRecord::Migration
  def up
    variants = Spree::Variant.where('electronic_delivery_keys > 0')
    variants.update_all(electronic_delivery: true)
  end

  def down
    Spree::Variant.update_all(electronic_delivery: false)
  end
end
