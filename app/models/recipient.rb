class Recipient
  def initialize(remote)
    @remote = remote
  end

  def id
    @remote.id
  end

  def last4
    @remote.active_account.last4
  end

  def bank_name
    @remote.active_account.bank_name
  end

  def self.create(attributes)
    new(Stripe::Recipient.create(attributes))
  end
end
