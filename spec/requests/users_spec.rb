require 'rails_helper'

RSpec.describe 'TransactionsController', type: :request do
  describe "GET /Transactions" do
    before do
      sign_in create(:user)
    end
  end

end