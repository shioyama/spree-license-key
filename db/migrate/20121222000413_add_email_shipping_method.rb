class AddEmailShippingMethod < ActiveRecord::Migration
  def up
    zone = Spree::Zone.first
    if zone
      shipping_method = Spree::ShippingMethod.new :name => Spree::ShippingMethod::ELECTRONIC_DELIVERY_NAME
      shipping_method.display_on = :back_end
      shipping_method.zone = zone
      shipping_method.calculator = Spree::Calculator::FlatPercentItemTotal.create!
      shipping_method.save!
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
