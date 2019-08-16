RSpec.describe Account do
  OVERRIDABLE_FILENAME = 'spec/fixtures/account.yml'.freeze

  ACCOUNT_VALIDATION_PHRASES = {
    name: {
      first_letter: 'Your name must not be empty and starts with first upcase letter'
    },
    login: {
      present: 'Login must present',
      longer: 'Login must be longer then 4 symbols',
      shorter: 'Login must be shorter then 20 symbols',
      exists: 'Such account is already exists'
    },
    password: {
      present: 'Password must present',
      longer: 'Password must be longer then 6 symbols',
      shorter: 'Password must be shorter then 30 symbols'
    },
    age: {
      length: 'Your Age must be greeter then 23 and lower then 90'
    }
  }.freeze

  let(:current_subject) { described_class.new }

  describe '#create' do
    let(:success_name_input) { 'Denis' }
    let(:success_age_input) { 72 }
    let(:success_login_input) { 'Denis' }
    let(:success_password_input) { 'Denis1993' }

    context 'with errors' do
      context 'with name errors' do
        context 'without small letter' do
          let(:error_input) { 'some_test_name' }
          let(:error) { ACCOUNT_VALIDATION_PHRASES[:name][:first_letter] }

          it do
            current_subject.instance_variable_set(:@database, Database.new)
            expect(current_subject.database).to receive(:load).and_return([])
            current_subject.create(error_input,
                                   success_age_input,
                                   success_login_input,
                                   success_password_input)
            expect(current_subject.errors).to eq [error]
          end
        end
      end

      context 'with login errors' do
        context 'when present' do
          let(:error_input) { '' }
          let(:error_one) { ACCOUNT_VALIDATION_PHRASES[:login][:present] }
          let(:error_two) { ACCOUNT_VALIDATION_PHRASES[:login][:longer] }

          it do
            current_subject.create(success_name_input,
                                   success_age_input,
                                   error_input,
                                   success_password_input)
            expect(current_subject.errors).to eq [error_one, error_two]
          end
        end

        context 'when longer' do
          let(:error_input) { 'E' * 3 }
          let(:error) { ACCOUNT_VALIDATION_PHRASES[:login][:longer] }

          it do
            current_subject.create(success_name_input,
                                   success_age_input,
                                   error_input,
                                   success_password_input)
            expect(current_subject.errors).to eq [error]
          end
        end

        context 'when shorter' do
          let(:error_input) { 'E' * 21 }
          let(:error) { ACCOUNT_VALIDATION_PHRASES[:login][:shorter] }

          it do
            current_subject.create(success_name_input,
                                   success_age_input,
                                   error_input,
                                   success_password_input)
            expect(current_subject.errors).to eq [error]
          end
        end
      end

      context 'with age errors' do
        let(:error) { ACCOUNT_VALIDATION_PHRASES[:age][:length] }

        context 'with length minimum' do
          let(:error_input) { 22 }

          it do
            current_subject.create(success_name_input,
                                   error_input,
                                   success_login_input,
                                   success_password_input)
            expect(current_subject.errors).to eq [error]
          end
        end

        context 'with length maximum' do
          let(:error_input) { 91 }

          it do
            current_subject.create(success_name_input,
                                   error_input,
                                   success_login_input,
                                   success_password_input)
            expect(current_subject.errors).to eq [error]
          end
        end
      end

      context 'with password errors' do
        context 'when absent' do
          let(:error_input) { '' }
          let(:error_one) { ACCOUNT_VALIDATION_PHRASES[:password][:present] }
          let(:error_two) { ACCOUNT_VALIDATION_PHRASES[:password][:longer] }

          it do
            current_subject.create(success_name_input,
                                   success_age_input,
                                   success_login_input,
                                   error_input)
            expect(current_subject.errors).to eq [error_one, error_two]
          end
        end

        context 'when longer' do
          let(:error_input) { 'E' * 5 }
          let(:error) { ACCOUNT_VALIDATION_PHRASES[:password][:longer] }

          it do
            current_subject.create(success_name_input,
                                   success_age_input,
                                   success_login_input,
                                   error_input)
            expect(current_subject.errors).to eq [error]
          end
        end

        context 'when shorter' do
          let(:error_input) { 'E' * 31 }
          let(:error) { ACCOUNT_VALIDATION_PHRASES[:password][:shorter] }

          it do
            current_subject.create(success_name_input,
                                   success_age_input,
                                   success_login_input,
                                   error_input)
            expect(current_subject.errors).to eq [error]
          end
        end
      end
    end
  end
end
