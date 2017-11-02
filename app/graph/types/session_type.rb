module Types
  SessionType = Session.to_graphql_type(
    fields: [
      :access_token
    ],
    relay: true
  )
end
