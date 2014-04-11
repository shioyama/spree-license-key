class AddPopulatorTypeToVariants < ActiveRecord::Migration
  def change
    add_column :spree_variants, :populator_type, :string
  end
end
