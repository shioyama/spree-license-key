Deface::Override.new(
  :virtual_path => "spree/checkout/_summary",
  :name => "no_zero_shipping_summary",
  :replace_contents => "#summary-order-charges",
  :partial => 'spree/checkout/summary_order_charges',
  :disabled => false
)

Deface::Override.new(
  :virtual_path => "spree/shared/_order_details",
  :name => "no_zero_shipping_order_details",
  :replace_contents => "#order-charges",
  :partial => 'spree/shared/order_details_adjustments',
  :disabled => false
)
