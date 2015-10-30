module Spree
  class InfiniteLicenseKeyPopulator < DefaultLicenseKeyPopulator
    def on_hand
      Float::INFINITY
    end
  end
end
