Fabricator(:wv_minecraft_183, from: :wonko_version) do
  wonko_file(fabricator: :wf_minecraft)
  user { User.official_user }
  origin { |attrs| WonkoOrigin.new(origin: attrs[:user], type: 'testing') }

  version '1.8.3'
  type 'release'
  time 1_424_440_809
end
Fabricator(:wv_minecraft_181, from: :wonko_version) do
  wonko_file(fabricator: :wf_minecraft)
  user { User.official_user }
  origin { |attrs| WonkoOrigin.new(origin: attrs[:user], type: 'testing') }

  version '1.8.1'
  type 'release'
  time 1_416_838_411
end
