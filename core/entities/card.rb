class Card

  def sender_balance(amount)
    @balance = @balance - amount - sender_tax(amount)
  end

  def recipient_balance(amount)
    @balance = @balance + amount - put_tax(amount)
  end

  def set_new_balance(amount)
    @balance = amount
  end

  def put_money(amount)
      @balance = @balance + amount - put_tax(amount)
  end

  def withdraw_money(amount)
    @balance - amount - withdraw_tax(amount)
  end

  def rand_number_card
    16.times.map{rand(10)}.join
  end

end
