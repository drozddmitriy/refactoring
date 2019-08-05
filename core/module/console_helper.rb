module ConsoleHelper
  def hello_console
    puts I18n.t(:hello_msg)
  end

  def message_input(message = nil)
    puts message
    gets.chomp
  end

  def message(message)
    puts message
  end

  def welcome_console(name)
    puts I18n.t(:welcome_console, name: name)
  end

  def create_card_console
    puts I18n.t(:create_card_console)
  end

  def message_put(amount, current_card)
    puts I18n.t(:message_put,
                amount: amount,
                number: current_card.number,
                balance: current_card.balance,
                put_tax: current_card.put_tax(amount))
  end

  def message_withdraw(amount, current_card)
    puts I18n.t(:message_withdraw,
                amount: amount,
                number: current_card.number,
                balance: current_card.balance,
                withdraw_tax: current_card.withdraw_tax(amount))
  end

  def check_tax(current_card, amount)
    current_card.put_tax(amount) * amount >= amount
  end

  def message_sender_card(amount, sender_card, recipient_balance)
    puts I18n.t(:message_sender,
                amount: amount,
                number: sender_card.number,
                balance: recipient_balance,
                put_tax: sender_card.put_tax(amount))
  end

  def message_recepient_card(amount, recipient_card, sender_balance, sender_card)
    puts I18n.t(:message_recepient,
                amount: amount,
                number: recipient_card.number,
                balance: sender_balance,
                sender_tax: sender_card.sender_tax(amount))
  end

  def cards_invalid?(sender_card, recipient_card)
    sender_card.number.empty? || recipient_card.number.empty?
  end
end
