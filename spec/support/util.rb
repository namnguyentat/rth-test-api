def graphql_id(object, id = nil)
  if object.is_a?(Class) || object.is_a?(String)
    raise 'id must be a FixNum' unless id.is_a?(Integer)
    Base64.urlsafe_encode64("#{object}---#{id}")
  else
    Base64.urlsafe_encode64("#{object.class}---#{object.id}")
  end
end

def login_as_user(user = nil)
  user ||= create(:user, onboarding: 'completed')
  user.reload
  allow_any_instance_of(ApplicationController).to receive(:current_user) { user }
  user
end

def generate_content_state(str, inlineStyleRanges = [])
  {
    entityMap: {},
    blocks: [
      {
        key: '5g99a',
        text: str,
        type: 'unstyled',
        depth: 0,
        inlineStyleRanges: inlineStyleRanges,
        entityRanges: [],
        data: {}
      }
    ]
  }.to_json
end

def content_state_to_text(str)
  state = JSON.parse(str)
  state['blocks'].map { |block| block['text'] }.join
end
