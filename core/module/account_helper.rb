module AccountHelper
  def puts_errors(errors)
    errors.each { |error| puts error }
  end

  def validate(account)
    validate_name(account)
    validate_age(account)
    validate_login(account)
    validate_password(account)
  end

  def validate_name(account)
    return unless account.name.empty? || account.name[0].upcase != account.name[0]

    account.errors.push(I18n.t(:name_not_be_empty))
  end

  def validate_age(account)
    account.errors.push(I18n.t(:age_be_greeter)) unless account.age.between?(23, 89)
  end

  def validate_login(account)
    account.errors.push(I18n.t(:login_must_present)) if account.login.empty?
    account.errors.push(I18n.t(:login_be_longer)) if account.login.length < 4
    account.errors.push(I18n.t(:login_be_shorter)) if account.login.length > 20
    account.errors.push(I18n.t(:account_exists)) if account.database.load.map(&:login).include?(account.login)
  end

  def validate_password(account)
    account.errors.push(I18n.t(:password_must_present)) if account.password.empty?
    account.errors.push(I18n.t(:password_be_longer)) if account.password.length < 6
    account.errors.push(I18n.t(:password_be_shorter)) if account.password.length > 30
  end

  def validate_input_cards(answer, account)
    answer.to_i <= account.cards.length && answer.to_i.positive?
  end

  def card_valid_number(number)
    number.length > 15 && number.length < 17
  end

  def card_exist?(all_cards, number)
    all_cards.select { |card| card.number == number }.any?
  end
end
