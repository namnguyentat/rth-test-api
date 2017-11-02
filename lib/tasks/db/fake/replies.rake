namespace :db do
  namespace :fake do
    desc 'create sample replies'
    task replies: :environment do
      users = User.all
      comments = Comment.all

      ActiveRecord::Base.transaction do
        300.times do
          Reply.create!(
            user: users.sample,
            comment: comments.sample,
            content: Faker::Lorem.sentence
          )
        end
      end

      puts "#{Reply.count} replies created"
    end
  end
end
