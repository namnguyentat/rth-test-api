require 'task_helpers/application_helper'

namespace :db do
  namespace :fake do
    desc 'create sample posts'
    task posts: :environment do
      users = User.all

      30.times do
        Post.create!(
          user: users.sample,
          title: Faker::Lorem.sentence,
          image: 'http://via.placeholder.com/700x300',
          content: ApplicationHelper.generate_content_state(Faker::Lorem.paragraph(10))
        )
      end

      puts "#{Post.count} posts created"
    end
  end
end
