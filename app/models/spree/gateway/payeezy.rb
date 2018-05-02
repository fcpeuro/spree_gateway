module Spree
  class Gateway::Payeezy < Gateway
    preference :login, :string

    def provider_class
      ActiveMerchant::Billing::PayeezyGateway
    end
  end
end
