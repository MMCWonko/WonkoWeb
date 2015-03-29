Fabricator(:wv_minecraft_183, from: :wonko_version) do
  wonkofile(fabricator: :wf_minecraft)
  user { User.find_by(username: 'Official') }

  version '1.8.3'
  type 'release'
  time 1_424_440_809
  requires []
  data []
  origin 'user_upload'
end
Fabricator(:wv_minecraft_181, from: :wonko_version) do
  wonkofile(fabricator: :wf_minecraft)
  user { User.find_by(username: 'Official') }

  version '1.8.1'
  type 'release'
  time 1_416_838_411
  requires []
  data []
  origin 'user_upload'
end
