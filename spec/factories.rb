FactoryGirl.define do
  factory :wonko_file_minecraft, class: WonkoFile do
    uid 'net.minecraft'
    name 'Minecraft'
    user { User.find_by(username: 'Official') }
  end

  factory :wonko_version_minecraft_183, class: WonkoVersion do
    wonkofile { FactoryGirl.create(:wonko_file_minecraft) }
    user { User.find_by(username: 'Official') }

    version '1.8.3'
    type 'release'
    time 1_424_440_809
    requires []
    data []
    origin 'user_upload'
  end
end
