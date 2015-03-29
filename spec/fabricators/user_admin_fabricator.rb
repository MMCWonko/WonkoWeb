Fabricator(:user_admin, from: :user) do
  admin true
  email { sequence(:email) { |n| "admin#{n}@example.com" } }
  username { sequence(:name) { |n| "admin#{n}" } }
  password 'testtest'
  password_confirmation 'testtest'
end
