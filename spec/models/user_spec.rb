require 'rails_helper'

RSpec.describe User, type: :model do

  it '1. returns the email of the user' do
    user = build(:user, email: 'tester@email.com', password: 'password', role: 0, 'confirmed_at': DateTime.now, first_name: 'tester', last_name: 'tester')

    expect(user.email).to eq 'tester@email.com'
    expect(user.role).to eq 'user'
  end

  it '2. the default role is "user"' do
    user = build(:user, email: 'tester@email.com', password: 'password', 'confirmed_at': DateTime.now, first_name: 'tester', last_name: 'tester')

    expect(user.role).to eq 'user'
  end

  # it 'will not register if there is no first name and last name' do
    # user = build(:user, email: 'tester@email.com', password: 'password', 'confirmed_at': DateTime.now)
    # expect(user).to be_valid

    # expect(create(:user, email: 'tester@email.com', password: 'password', 'confirmed_at': DateTime.now)).to be_valid
    
    # raise_error(ActiveRecord::RecordInvalid, "First name can't be blank, Last name can't be blank")

  # end

end
