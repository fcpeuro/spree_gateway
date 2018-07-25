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
      if payment.source.gateway_customer_profile_id.nil?
        response = provider.store(payment.source, options_for_payment)
        
        if response.success?
          payment.source.update_attributes!(:gateway_customer_profile_id => response.authorization)
        else
          payment.send(:gateway_error, response.message)
        end
      end
    end

    private
    
    def options_for_payment
      opts = {}
      opts[:ta_token] = "NOIW"
      opts
    end
    
  end
end
