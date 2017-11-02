module Fields
  module EntryPoint
    ViewerField = GraphQL::Field.define do
      name 'viewer'
      description 'Root object to get viewer related collections'

      type Types::ViewerType

      resolve ->(_obj, _args, _ctx) do
        Viewer::STATIC
      end
    end
  end
end
