namespace :db do
  desc 'sanitize database'
  task sanitize: ['sanitize:all']

  namespace :sanitize do
    task all: [
      :notifications
    ]
  end
end
