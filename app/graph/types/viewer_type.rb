module Types
  ViewerType = GraphQL::ObjectType.define do
    # Hack to support root queries
    name 'Viewer'
    description 'Support unassociated root queries that fetches collections.'

    interfaces [GraphQL::Relay::Node.interface]

    field :id, !types.ID, 'Viewer ID' do
      resolve ->(_obj, _args, _ctx) { 'client:root:viewer' }
    end

    field :current_user, field: Fields::EntryPoint::CurrentUserField
    connection :posts, field: Fields::EntryPoint::PostsField, max_page_size: Settings.graph.max_page_size
  end
end
