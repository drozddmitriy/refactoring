class Account
  include AccountHelper
  attr_accessor :login, :name, :cards, :age, :password, :database, :errors

  def initialize
    @errors = []
    @database = Database.new
  end

  def create(name, age, login, password)
    @name = name
    @age = age
    @login = login
    @password = password
    validate(self)

    @cards = []
  end

  def destroy
    accounts = @database.load
    accounts.reject! { |account| account.login == login }
    @database.save(accounts)
  end

  def create_card(type)
    case type
    when 'usual' then @cards << Usual.new
    when 'capitalist' then @cards << Capitalist.new
    when 'virtual' then @cards << Virtual.new
    end
    save_account
  end

  def save_account
    accounts = @database.load.map { |account| account.login == login ? self : account }

    @database.save(accounts)
  end

  def current_card(index)
    cards[index.to_i - 1]
  end

  def destroy_card(answer)
    cards.delete_at(answer.to_i - 1)
    save_account
  end

  def save_recepient(recipient, recipient_card, recipient_balance)
    recipient.cards.each do |card|
      card.balance = recipient_balance if card.number == recipient_card.number
    end
    recipient
  end

  def save_after_transaction(recipient_card, recipient_balance)
    new_accounts = []
    @database.load.each do |account|
      if account.login == login
        new_accounts.push(self)
      elsif account.cards.map(&:number).include? recipient_card.number
        recipient = save_recepient(account, recipient_card, recipient_balance)
        new_accounts.push(recipient)
      end
    end

    @database.save(new_accounts)
  end
end
