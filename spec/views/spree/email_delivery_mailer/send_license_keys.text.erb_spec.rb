require 'spec_helper'

describe 'spree/email_delivery_mailer/send_license_keys.text.erb' do
  let(:license_key) { stub_model Spree::LicenseKey, license_key: 'ABC-123-DEF', license_key_type: license_key_type }
  let(:variant) { stub_model Spree::Variant, name: "VARIANT" }
  let(:license_key_type) { nil }

  before do
    assign(:inventory_units, [
      stub_model(Spree::InventoryUnit, variant: variant, license_keys: [license_key]),
    ])
    render
  end

  subject { rendered }

  it { should =~ /#{t('spree.email_delivery_mailer.send_license_keys.title')}/ }
  it { should =~ /VARIANT: ABC-123-DEF/ }

  context "when license key has a variant type" do
    let(:license_key_type) { create :license_key_type, slug: "LK_SLUG"}

    it { should =~ /VARIANT \(LK_SLUG\): ABC-123-DEF/ }
  end

end
