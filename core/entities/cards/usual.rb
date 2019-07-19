class Usual < Card
  attr_accessor :balance, :number, :type

  def initialize
    @type = 'usual'
    @number = rand_number_card
    @balance = 50
  end

  def withdraw_tax(amount)
    amount * 0.05
  end

  def put_tax(amount)
    amount * 0.02
  end

  def sender_tax(_amount)
    20
  end
end
