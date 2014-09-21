class Customer
  def initialize(customer)
    @customer = customer
  end

  def id
    @customer.id
  end

  def last_four_of_card
    @customer.cards.data[0].last4
  end

  def self.update(payment_method)
    begin
      customer = Stripe::Customer.retrieve(payment_method.remote_id)
      customer.card = build_card(payment_method)
      customer.save
      new(customer)
    rescue Stripe::CardError => e
      raise_customer_card_error(e)
    end
  end

  def self.create(payment_method, user)
    begin
      new(Stripe::Customer.create(card: build_card(payment_method),
                                  description: user.email))
    rescue Stripe::CardError => e
      raise_customer_card_error(e)
    end
  end

  def self.delete(remote_id)
    customer = Stripe::Customer.retrieve(remote_id)
    customer.delete
  end

  private
  def self.raise_customer_card_error(error)
    raise Customer::CardError.new(error.message, error.http_status, error.http_body)
  end

  def self.build_card(payment_method)
    { name: payment_method.name_on_card,
      number: payment_method.number,
      exp_month: payment_method.exp_month,
      exp_year: payment_method.exp_year,
      cvc: payment_method.cvc }
  end

  class CardError < Stripe::CardError; end
end
