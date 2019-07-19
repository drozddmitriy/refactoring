module ConsoleHelper

  def hello_console
    puts 'Hello, we are RubyG bank!'
    puts '- If you want to create account - press `create`'
    puts '- If you want to load account - press `load`'
    puts '- If you want to exit - press `exit`'
  end

  def message_input(message = nil)
    puts message
    gets.chop
  end

  def message(message)
    puts message
  end

  def welcome_console(name)
    puts "\nWelcome, #{name}"
    puts 'If you want to:'
    puts '- show all cards - press SC'
    puts '- create card - press CC'
    puts '- destroy card - press DC'
    puts '- put money on card - press PM'
    puts '- withdraw money on card - press WM'
    puts '- send money to another card  - press SM'
    puts '- destroy account - press `DA`'
    puts '- exit from account - press `exit`'
  end

  def create_card_console
    puts 'You could create one of 3 card types'
    puts '- Usual card. 2% tax on card INCOME. 20$ tax on SENDING money from this card. 5% tax on WITHDRAWING money. For creation this card - press `usual`'
    puts '- Capitalist card. 10$ tax on card INCOME. 10% tax on SENDING money from this card. 4$ tax on WITHDRAWING money. For creation this card - press `capitalist`'
    puts '- Virtual card. 1$ tax on card INCOME. 1$ tax on SENDING money from this card. 12% tax on WITHDRAWING money. For creation this card - press `virtual`'
    puts '- For exit - press `exit`'
  end

  def message_put(amount, current_card)
    message("Money #{amount} was put on #{current_card.number}. Balance: #{current_card.balance}. Tax: #{current_card.put_tax(amount)}")
  end

  def message_withdraw(amount, current_card)
    puts "Money #{amount} withdrawed from #{current_card.number}$. Money left: #{current_card.balance}$. Tax: #{current_card.withdraw_tax(amount)}$"
  end

  def check_tax(current_card, amount)
    current_card.put_tax(amount) * amount >= amount
  end

  def message_sender_card(amount, sender_card, recipient_balance)
    puts "Money #{amount}$ was put on #{sender_card.number}. Balance: #{recipient_balance}. Tax: #{sender_card.put_tax(amount)}$\n"
  end

  def message_recepient_card(amount, recipient_card, sender_balance, sender_card)
    puts "Money #{amount}$ was put on #{recipient_card.number}. Balance: #{sender_balance}. Tax: #{sender_card.sender_tax(amount)}$\n"
  end

  def cards_invalid?(sender_card, recipient_card)
    sender_card.empty? || recipient_card.empty?
  end



end
