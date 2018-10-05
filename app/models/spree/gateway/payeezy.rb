module Spree
  class Gateway::Payeezy < Gateway
    preference :apikey,    :string
    preference :apisecret, :string
    preference :token,     :string
    preference :ta_token,  :string

    def provider_class
      ActiveMerchant::Billing::PayeezyGateway
    end

    def payment_profiles_supported?
      true
    end

    def create_profile(payment)
      if existing_profile_not_present?(payment)
        response = provider.store(payment.source, preferences)
        
        if response.success?
          payment.source.update_attributes!(:gateway_customer_profile_id => response.authorization)
        else
          payment.send(:gateway_error, response.message)
        end
      end
    end

    private
    
    def existing_profile_not_present?(payment)
      source = payment.source
      
      # Check to see if card is already saved
      matching_sources = payment.order.user.payment_sources.where(
        cc_type: source.cc_type, 
        last_digits: source.last_digits, 
        month: source.month, 
        year: source.year
      )
      
      payment.source.gateway_customer_profile_id.nil? && matching_sources.blank?
    end
    
  end
end
