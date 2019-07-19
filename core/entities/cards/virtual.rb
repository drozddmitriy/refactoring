class Virtual < Card
  attr_accessor :balance, :number, :type

  def initialize
    @type = 'virtual'
    @number = rand_number_card
    @balance = 150
  end

  def withdraw_tax(amount)
    amount * 0.88
  end

  def put_tax(_amount)
    1
  end

  def sender_tax(_amount)
    1
  end
end
