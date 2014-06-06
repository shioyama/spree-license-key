Spree::OrderPopulator.class_eval do
  # Adds optional hash to value of parameters passed to OrderPopulator.
  # These options are passed to Spree::LineItem#assign_options! to assign them
  # to the line item.
  #
  # Default single variant/quantity pairing:
  # +:variants => { variant_id => quantity }+
  #
  # With options:
  # +:variants => { variant_id => { option_key_1 => option_value_1, option_key_2 => option_value_2, ..., :quantity => quantity }
  #
  # If no quantity key/value pair is passed in the options, the quantity defaults to 1.
  def populate_with_options(from_hash)
    if from_hash[:variants] && (variants_with_options = from_hash[:variants].select { |variant_id, quantity| quantity.is_a?(Hash) })
      variants_with_options.each do |variant_id, options|
        options = options.with_indifferent_access
        quantity = options.delete(:quantity) || 1
        attempt_cart_add(variant_id, quantity)

        if (line_item = order.line_items.where(variant_id: variant_id).first)
          line_item.assign_options!(options)
        end

        from_hash[:variants].delete(variant_id)
      end
    end
    populate_without_options(from_hash)
  end

  alias_method_chain :populate, :options
end
