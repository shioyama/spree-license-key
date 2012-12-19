module Spree
  class LicenseKey < ActiveRecord::Base
    belongs_to :user, :class_name => Spree.user_class
    belongs_to :variant, :class_name => "Spree::Variant"

    attr_accessible :license_key, :user_id, :variant_id

    def self.next!(variant, user)
      transaction do
        license_key = self.where(:variant_id => variant.id, :user_id => nil).first
        if license_key.nil?
          raise LicenseKey::InsufficientLicenseKeys, variant.inspect
        end
        license_key.user = user
        license_key.save!
        license_key
      end
    end

    class InsufficientLicenseKeys < ::StandardError; end
  end
end
