FactoryBot.define do
  factory(:user) do
    email { "testing@email.com"}
    password { "password" }
    role { 0 }
    confirmed_at { DateTime.now }
    first_name { "tester" }
    last_name { "tester" }
  end
end