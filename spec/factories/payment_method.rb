FactoryGirl.define do
  factory :payment_method do
    name_on_card 'Joseph Sak'
    brand 'Visa'
    number 4111111111111111
    exp_month '01'
    exp_year Time.current.year + 1
    cvc 123
    account
  end
end
