require 'rails_helper'

RSpec.describe 'TransactionsController', type: :request do

  describe "GET /top_ten" do
    get '/top_ten'

    expect(response).to have_http_status(:success)
    result = JSON.parse(response.body)['count']
    

  end

end