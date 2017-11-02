namespace :db do
  namespace :fake do
    desc 'create sample users'
    task users: :environment do
      avatars = %w(
        http://malemoods.creaemotions.com/images/images_g/male_moods_j01_39.jpg
        https://cdn4.iconfinder.com/data/icons/samurai/512/Geisha-512.png
        https://cdn4.iconfinder.com/data/icons/samurai/512/Ronin_1-512.png
        https://cdn4.iconfinder.com/data/icons/samurai/512/Elderly-512.png
        http://www.otakutale.com/wp-content/uploads/2014/01/Want-a-Quality-Custom-Made-Japanese-Avatar-pic-1.jpg
        https://cdn2.iconfinder.com/data/icons/ninja/500/Ninja_4-512.png
        https://cdn4.iconfinder.com/data/icons/samurai/512/Kendo_Master-512.png
        https://cdn4.iconfinder.com/data/icons/cia-operations/512/ninja-512.png
        http://static-resource.np.community.playstation.net/avatar/3RD/JP00311208008_B4C4A21744E6FE709446_L.png
        https://cdn4.iconfinder.com/data/icons/samurai/512/Ninja_1-512.png
      )
      avatars.count.times do
        User.create!(
          name: Faker::Name.name,
          email: Faker::Internet.email,
          about: Faker::Lorem.sentence,
          avatar: avatars.pop,
          job: Faker::Job.title,
          company: Faker::Company.name,
          onboarding: User.onboardings.keys.last
        )
      end

      Session.create(user: User.first, access_token: '123456789', expires_at: 6.months.from_now)
      Session.create(user: User.find(2), access_token: '1234567890', expires_at: 6.months.from_now)
      Session.create(user: User.find(3), access_token: '12345678901', expires_at: 6.months.from_now)
      Session.create(user: User.find(4), access_token: '123456789012', expires_at: 6.months.from_now)

      puts "#{User.count} users created"
      puts "#{Session.count} sessions created"
    end
  end
end
