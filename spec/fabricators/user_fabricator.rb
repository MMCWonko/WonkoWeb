Fabricator(:user) do
  email { sequence(:email) { |n| "user#{n}@example.com" } }
  username { sequence(:name) { |n| "user#{n}" } }
  password 'testtest'
  password_confirmation 'testtest'
end
