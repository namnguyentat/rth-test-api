namespace :db do
  namespace :fake do
    desc 'create sample upvotes'
    task upvotes: :environment do
      ActiveRecord::Base.transaction do
        Post.all.each do |post|
          User.all.each do |upvoter|
            next if rand(8) != 0
            post.upvoters << upvoter
          end
        end
      end

      ActiveRecord::Base.transaction do
        Comment.all.each do |comment|
          User.all.each do |upvoter|
            next if rand(10) != 0
            next if upvoter == comment.user
            comment.upvoters << upvoter
          end
        end
      end

      ActiveRecord::Base.transaction do
        Reply.all.each do |reply|
          User.all.each do |upvoter|
            next if rand(10) != 0
            next if upvoter == reply.user
            reply.upvoters << upvoter
          end
        end
      end

      puts "#{Upvote.count} upvotes created"
    end
  end
end
