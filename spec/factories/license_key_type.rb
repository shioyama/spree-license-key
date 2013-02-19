FactoryGirl.define do
  factory :license_key_type, :class => "Spree::LicenseKeyType" do
    sequence(:slug) { |n| "slug-#{n}" }
  end
end
