require 'spec_helper'

describe 'spree/email_delivery_mailer/send_license_keys.text.erb' do
  let(:license_keys) { stub_model Spree::LicenseKey, license_key: 'ABC-123-DEF' }
  let(:variant) { stub_model Spree::Variant, name: "VARIANT" }

  before do
    assign(:inventory_units, [
      stub_model(Spree::InventoryUnit, variant: variant, license_keys: [license_keys]),
    ])
    render
  end

  subject { rendered }

  it { should =~ /VARIANT: ABC-123-DEF/ }

end
