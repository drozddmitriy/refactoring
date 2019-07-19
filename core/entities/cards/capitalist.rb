class Capitalist < Card
  attr_accessor :balance, :number, :type

  def initialize
    @type = 'capitalist'
    @number = rand_number_card
    @balance = 100
  end

  def withdraw_tax(amount)
    amount * 0.04
  end

  def put_tax(_amount)
    10
  end

  def sender_tax(amount)
    amount * 0.1
  end
end
