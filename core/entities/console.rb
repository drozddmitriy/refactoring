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
      name = message_input(I18n.t(:input_name))
      age = message_input(I18n.t(:input_age)).to_i
      login = message_input(I18n.t(:input_login))
      password = message_input(I18n.t(:input_password))
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
      login = message_input(I18n.t(:input_login))
      password = message_input(I18n.t(:input_password))
      @account = @database.select_account(login, password)
      break unless @account.nil?

      message(I18n.t(:no_account))
    end
    main_menu
  end

  def create_the_first_account
    return create_account if message_input(I18n.t(:no_active_accounts)) == 'y'

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
      when 'DA' then destroy_account
      when 'exit' then exit
      else message(I18n.t(:wrong_command))
      end
    end
  end

  def create_card
    array = %w[usual capitalist virtual]
    create_card_console
    answer = message_input
    return if answer == 'exit'

    return message(I18n.t(:wrong_card_type)) unless array.include? answer

    @account.create_card(answer)
  end

  def show_cards
    return message(I18n.t(:no_active_cards)) if @account.cards.none?

    @account.cards.each { |card| message("- #{card.number}, #{card.type}") }
  end

  def destroy_account
    @account.destroy if message_input(I18n.t(:you_want_to_destroy)) == 'y'
    exit
  end

  def destroy_card
    return message(I18n.t(:no_active_cards)) if @account.cards.none?

    list_cards
    answer = message_input
    return if answer == 'exit'

    return message(I18n.t(:wrong_number)) unless @account.validate_input_cards(answer, @account)

    return if message_input(I18n.t(:you_want_to_delete, number: @account.current_card(answer).number)) != 'y'

    @account.destroy_card(answer)
  end

  def list_cards
    message(I18n.t(:if_you_want_tp_delete))
    @account.cards.each_with_index do |card, i|
      message(I18n.t(:list_cards, number: card.number, type: card.type, i: i + 1))
    end
    message(I18n.t(:press_exit))
  end

  def put_money
    message(I18n.t(:choose_card_for_put))
    return message(I18n.t(:no_active_cards)) if @account.cards.none?

    list_cards
    answer = message_input
    return if answer == 'exit'

    return message(I18n.t(:wrong_number)) unless @account.validate_input_cards(answer, @account)

    current_card = @account.current_card(answer)
    amount = message_input(I18n.t(:input_amount_to_put_on_card)).to_i
    return message(I18n.t(:input_correct_amount)) unless amount.positive?

    return message(I18n.t(:you_tax_is_higher)) if check_tax(current_card, amount)

    current_card.put_money(amount)
    message_put(amount, current_card)
    @account.save_account
  end

  def withdraw_money
    message(I18n.t(:choose_card_for_withdraw))
    return message(I18n.t(:no_active_cards)) if @account.cards.none?

    list_cards
    answer = message_input
    return if answer == 'exit'

    return message(I18n.t(:wrong_number)) unless @account.validate_input_cards(answer, @account)

    current_card = @account.current_card(answer)
    amount = message_input(I18n.t(:input_amount_to_withdraw)).to_i
    return message(I18n.t(:input_correct_dollar)) unless amount.positive?

    money_left = current_card.withdraw_money(amount)
    return message(I18n.t(:dont_have_enough_money)) unless money_left.positive?

    current_card.new_balance(money_left)
    message_withdraw(amount, current_card)
    @account.save_account
  end

  def send_money
    sender_card = select_sender_card
    recipient_card = select_recipient_card
    return if cards_invalid?(sender_card, recipient_card)
    amount = message_input(I18n.t(:input_amount_to_withdraw)).to_i
    return message(I18n.t(:wrong_number)) unless amount.positive?

    sender_balance = sender_card.sender_balance(amount)
    recipient_balance = recipient_card.recipient_balance(amount)
    return message(I18n.t(:dont_have_enough_money)) unless sender_balance.positive?

    return message(I18n.t(:no_money_sender_card)) if recipient_card.put_tax(amount) >= amount

    message_sender_card(amount, sender_card, recipient_balance)
    message_recepient_card(amount, recipient_card, sender_balance, sender_card)
    @account.save_after_transaction(recipient_card, recipient_balance)
  end

  def select_sender_card
    message(I18n.t(:choose_card_for_send))
    return message(I18n.t(:no_active_cards)) if @account.cards.none?

    list_cards
    answer = message_input
    return if answer == 'exit'

    return message(I18n.t(:choose_correct_card)) unless @account.validate_input_cards(answer, @account)

    @account.current_card(answer)
  end

  def select_recipient_card
    number = message_input(I18n.t(:input_recipient_card))
    return message(I18n.t(:please_input_correct_number)) unless @account.card_valid_number(number)

    all_cards = @database.load_cards
    return message(I18n.t(:no_card_with_number, number: number)) unless @account.card_exist?(all_cards, number)

    all_cards.detect { |card| card.number == number }
  end
end
