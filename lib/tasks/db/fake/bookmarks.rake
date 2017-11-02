namespace :db do
  namespace :fake do
    desc 'create sample bookmarks'
    task bookmarks: :environment do
      ActiveRecord::Base.transaction do
        Post.all.each do |post|
          User.all.each do |bookmarker|
            next if rand(5) != 0
            post.bookmarkers << bookmarker
          end
        end
      end

      puts "#{Bookmark.count} bookmarks created"
    end
  end
end
