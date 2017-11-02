namespace :db do
  namespace :fake do
    desc 'create sample follows'
    task follows: :environment do
      ActiveRecord::Base.transaction do
        User.all.each do |user|
          User.all.each do |follower|
            next if rand(5) != 0 || user.id == follower.id
            user.followers << follower
          end
        end
      end

      puts "#{Follow.count} follows created"
    end
  end
end
