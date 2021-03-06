Fabricator(:wf_minecraft, from: :wonko_file) do
  uid { sequence(:uid) { |n| "net.minecraft.#{n}" } }
  name 'Minecraft'
  user { User.official_user }
  origin { |attrs| WonkoOrigin.new(origin: attrs[:user], type: 'testing') }
end
