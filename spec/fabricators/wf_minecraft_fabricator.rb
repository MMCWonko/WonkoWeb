Fabricator(:wf_minecraft, from: :wonko_file) do
  uid 'net.minecraft'
  name 'Minecraft'
  user { User.find_by(username: 'Official') }
end
