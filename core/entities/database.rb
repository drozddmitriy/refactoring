class Database
  FILE_NAME = 'accounts.yml'.freeze

  def save(accounts)
    File.open(FILE_NAME, 'w') { |file| file.write accounts.to_yaml }
  end

  def load
    File.exist?(FILE_NAME) ? YAML.load_file(FILE_NAME) : []
  end

  def select_account(login, password)
    load.find { |account| account.login == login && account.password == password }
  end

  def load_cards
    load.map(&:cards).flatten
  end
end
