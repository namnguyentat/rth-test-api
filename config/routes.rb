require 'sidekiq/web'

if !Rails.env.production?
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV['SIDEKIQ_USERNAME'] && password == ENV['SIDEKIQ_PASSWORD']
  end
end

Rails.application.routes.draw do
  mount Sidekiq::Web, at: '/skmnt'

  # GraphQL
  resources :queries, only: :create
  resources :client_logs, only: :create
  resources :posts, only: [:index, :show]
  resource :sha, only: :show

  # GraphiQL
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/queries'
    root to: redirect('/graphiql')
  end
end
