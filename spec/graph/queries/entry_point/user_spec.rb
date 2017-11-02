require 'rails_helper'

RSpec.describe 'User', type: :graph do
  let(:query) {
    "query User($id: GlobalIdInput!) {
      user(id: $id) {
        id
        name
      }
    }"
  }
  let(:variables) { {'id' => sample_id} }

  context 'Result checking' do
    let!(:users) { create_list(:user, 3) }

    context 'User exist' do
      let(:sample_name) { 'This is a person' }
      let(:user) { create(:user, name: sample_name) }
      let(:sample_id) { graphql_id(user) }

      before(:each) do
        @result = AppSchema.execute(query, variables: variables)
      end

      it 'return correct result' do
        expect(@result['data'].deep_symbolize_keys).to eq(
          user: {
            id: sample_id,
            name: sample_name
          }
        )
      end
    end

    context 'User not exist' do
      let(:sample_id) { graphql_id(User, 0) }

      before(:each) do
        @result = AppSchema.execute(query, variables: variables)
      end

      it 'return correct result' do
        expect(@result['data'].deep_symbolize_keys).to eq(
          user: nil
        )
      end
    end
  end
end
