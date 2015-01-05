FactoryGirl.define do
  factory :electronic_variant, parent: :variant do |v|
    v.electronic_delivery_keys 1
    v.electronic_delivery true
  end
end
