namespace :db do
  desc 'create sample data'
  task fake: [
    'fake:all'
  ]

  namespace :fake do
    task all: [
      :users,
      :posts,
      :comments,
      :replies,
      :follows,
      :upvotes,
      :bookmarks,
      :notifications
    ]
  end
end
