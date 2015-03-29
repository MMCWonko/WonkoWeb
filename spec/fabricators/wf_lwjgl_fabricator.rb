Fabricator(:wf_lwjgl, from: :wonko_file) do
  uid 'org.lwjgl'
  name 'LWJGL'
  user { User.find_by(username: 'Official') }
end
