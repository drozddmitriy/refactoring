# frozen_string_literal: true

class Console
  include ConsoleHelper
  attr_accessor :account, :card, :database

  def initialize
    @account = Account.new
    @database = Database.new
  end

  def console
    hello_console

    case message_input
    when 'create' then create_account
    when 'load' then load
    else exit
    end
  end

  def create_account
    loop do
      name = message_input('Enter your name')
      age = message_input('Enter your age').to_i
      login = message_input('Enter your login')
      password = message_input('Enter your password')

      @account.create(name, age, login, password)

      break if @account.errors.size.zero?

      @account.puts_errors(@account.errors)
      @account.errors = []
    end

    @database.save(@database.load << @account)
    main_menu
  end

  def load
    return create_the_first_account if @database.load.none?

    loop do
      login = message_input('Enter your login')
      password = message_input('Enter your password')
      @account = @database.select_account(login, password)

      break unless @account.nil?

      message('There is no account with given credentials')
    end
    main_menu
  end

  def create_the_first_account
    return create_account if message_input('There is no active accounts, do you want to be the first?[y/n]') == 'y'

    console
  end

  def main_menu
    loop do
      welcome_console(@account.name)

      case message_input
      when 'SC' then show_cards
      when 'CC' then create_card
      when 'DC' then destroy_card
      when 'PM' then put_money
      when 'WM' then withdraw_money
      when 'SM' then send_money
      when 'DA' then
        destroy_account
        exit
      when 'exit' then exit
      else message('Wrong command. Try again!\n')
      end
    end
  end

  def create_card
    create_card_console

    array = %w[usual capitalist virtual]

    answer = message_input
    return if answer == 'exit'

    return message("Wrong card type. Try again!\n") unless array.include? answer

    @account.create_card(answer)
  end

  def show_cards
    return message("There is no active cards!\n") if @account.cards.none?

    @account.cards.each { |card| message("Card: #{card.number}, #{card.type}") }
  end

  def destroy_account
    message('Are you sure you want to destroy account?[y/n]')
    @account.destroy if message_input == 'y'
  end

  def destroy_card
    return message("There is no active cards!\n") if @account.cards.none?

    list_cards

    answer = message_input
    return if answer == 'exit'

    return message("You entered wrong number!\n") unless @account.validate_input_cards(answer, @account)

    message("Are you sure you want to delete #{@account.current_card(answer).number}?[y/n]")

    return if message_input != 'y'

    @account.destroy_card(answer)
  end

  def list_cards
    message('If you want to delete:')
    @account.cards.each_with_index { |card, i| message("- #{card.number}, #{card.type}, press #{i + 1}") }
    message("press `exit` to exit\n")
  end

  def put_money
    message('Choose the card for putting:')
    return message("There is no active cards!\n") if @account.cards.none?

    list_cards

    answer = message_input
    return if answer == 'exit'

    return message("You entered wrong number!\n") unless @account.validate_input_cards(answer, @account)

    current_card = @account.current_card(answer)

    amount = message_input('Input the amount of money you want to put on your card').to_i
    return message('You must input correct amount of money') unless amount.positive?

    return message('Your tax is higher than input amount') if check_tax(current_card, amount)

    current_card.put_money(amount)

    message_put(amount, current_card)

    @account.save_account
  end

  def withdraw_money
    message('Choose the card for withdrawing:')
    return message("There is no active cards!\n") if @account.cards.none?

    list_cards

    answer = message_input
    return if answer == 'exit'

    return message("You entered wrong number!\n") unless @account.validate_input_cards(answer, @account)

    current_card = @account.current_card(answer)

    amount = message_input('Input the amount of money you want to withdraw').to_i

    return message('You must input correct amount of $') unless amount.positive?

    money_left = current_card.withdraw_money(amount)

    return message("You don't have enough money on card for such operation") unless money_left.positive?

    current_card.set_new_balance(money_left)

    message_withdraw(amount, current_card)

    @account.save_account
  end

  def send_money
    sender_card = select_sender_card
    recipient_card = select_recipient_card

    # return if cards_invalid?(sender_card, recipient_card)

    amount = message_input('Input the amount of money you want to withdraw').to_i

    return message('You entered wrong number!\n') unless amount.positive?

    sender_balance = sender_card.sender_balance(amount)
    recipient_balance = recipient_card.recipient_balance(amount)

    return message("You don't have enough money on card for such operation") unless sender_balance.positive?

    return message('There is no enough money on sender card') if recipient_card.put_tax(amount) >= amount

    message_sender_card(amount, sender_card, recipient_balance)
    message_recepient_card(amount, recipient_card, sender_balance, sender_card)

    @account.save_after_transaction(recipient_card, recipient_balance)
  end

  def select_sender_card
    message('Choose the card for sending:')
    return message("There is no active cards!\n") if @account.cards.none?

    list_cards

    answer = message_input
    return if answer == 'exit'
    return message('Choose correct card') unless @account.validate_input_cards(answer, @account)

    @account.current_card(answer)
  end

  def select_recipient_card
    number = message_input('Enter the recipient card:')
    return message('Please, input correct number of card') unless @account.card_valid_number(number)

    all_cards = @database.load_cards
    return message("There is no card with number #{number}\n") unless @account.card_exist?(all_cards, number)

    all_cards.detect { |card| card.number == number }
  end
end
