official_pass = Faker::Internet.password
official = User.new(username: 'Official',
                    email: 'official@example.org',
                    password: official_pass)
official.save!

if Rails.env.development?
  # users
  users = [official, official]
  5.times do
    password = Faker::Internet.password
    user = User.new(username: Faker::Internet.user_name,
                    email: Faker::Internet.email,
                    password: password)
    user.save!
    users << user
  end

  # files
  files = []
  20.times do
    name = Faker::App.name
    uid = Faker::Internet.slug([Faker::Lorem.words(2), name.downcase].flatten.join(' '), '.')
    file = WonkoFile.new(uid: uid,
                         name: name)
    file.user = users.sample
    file.save!
    files << file
    10.times do
      begin
        version = file.wonkoversions.create!(
          version: Faker::App.version,
          type: Faker::Lorem.word,
          time: Faker::Time.between(1000.days.ago, Time.now).to_i
        )
        version.user = users.sample
        fail users.inspect unless version.user
        if !files.empty? && Faker::Number.digit.to_i >= 5
          version.requires = [{
            uid: files.sample
          }]
        end
        version.data = []
        version.save!
    rescue NoMethodError
      Rails.logger.info 'Unable to create ' + version.version
      end
    end
  end
end
