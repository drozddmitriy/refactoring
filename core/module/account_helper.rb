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

      account.errors.push('Your name must not be empty and starts with first upcase letter')
    end

    def validate_age(account)
      account.errors.push('Your Age must be greeter then 23 and lower then 90') unless account.age.between?(23, 89)
    end

    def validate_login(account)
      account.errors.push('Login must present') if account.login.empty?
      account.errors.push('Login must be longer then 4 symbols') if account.login.length < 4
      account.errors.push('Login must be shorter then 20 symbols') if account.login.length > 20
      account.errors.push('Such account is already exists') if account.database.load.map(&:login).include?(account.login)
    end

    def validate_password(account)
      account.errors.push('Password must present') if account.password.empty?
      account.errors.push('Password must be longer then 6 symbols') if account.password.length < 6
      account.errors.push('Password must be shorter then 30 symbols') if account.password.length > 30
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
