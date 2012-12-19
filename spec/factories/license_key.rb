FactoryGirl.define do
  factory :license_key, :class => "Spree::LicenseKey" do
    sequence(:license_key) { |n| "LICENSE_KEY-#{n}" }
    association :variant
  end
end
