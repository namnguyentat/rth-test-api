namespace :db do
  namespace :fake do
    desc 'create sample comments'
    task comments: :environment do
      users = User.all
      posts = Post.all

      ActiveRecord::Base.transaction do
        (posts.length * 20).times do
          Comment.create!(
            user: users.sample,
            commentable: posts.sample,
            content: Faker::Lorem.sentence
          )
        end
      end

      puts "#{Comment.count} comments created"
    end
  end
end
