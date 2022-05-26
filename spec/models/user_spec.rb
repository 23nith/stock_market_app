require 'rails_helper'

RSpec.describe User, type: :model do

  it 'returns the email of the user' do
    user = build(:user, email: 'tester@email.com', password: 'password', role: 0, 'confirmed_at': DateTime.now, first_name: 'tester', last_name: 'tester')

    expect(user.email).to eq 'tester@email.com'
    expect(user.role).to eq 'user'
  end

  it 'the default role is "user"' do
    user = build(:user, email: 'tester@email.com', password: 'password', 'confirmed_at': DateTime.now, first_name: 'tester', last_name: 'tester')

    expect(user.role).to eq 'user'
  end

  # it 'will not register if there is no first name and last name' do
  #   user = build(:user, email: 'tester@email.com', password: 'password', 'confirmed_at': DateTime.now)


  #   expect{create(:user, email: 'tester@email.com', password: 'password', 'confirmed_at': DateTime.now)}.to raise_exception(ActiveRecord::RecordInvalid, "First name can't be blank, Last name can't be blank")

    # ActiveRecord::RecordInvalid
  # end



end
