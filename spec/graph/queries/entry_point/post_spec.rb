require 'rails_helper'

RSpec.describe 'Post', type: :graph do
  let(:query) {
    "query Post($id: GlobalIdInput!) {
      post(id: $id) {
        id
        title
        content
      }
    }"
  }
  let(:variables) { {'id' => sample_id} }

  context 'Result checking' do
    let!(:posts) { create_list(:post, 3) }

    context 'Post exist' do
      let(:sample_title) { 'This is a title' }
      let(:sample_content) { 'This is a post' }
      let!(:post) { create(:post, title: sample_title, content: sample_content) }
      let(:sample_id) { graphql_id(post) }

      before(:each) do
        @result = AppSchema.execute(query, variables: variables)
      end

      it 'return correct result' do
        expect(@result['data'].deep_symbolize_keys).to eq(
          post: {
            id: sample_id,
            title: sample_title,
            content: post.content
          }
        )
      end
    end

    context 'Post not exist' do
      let(:sample_id) { graphql_id(Post, 0) }

      before(:each) do
        @result = AppSchema.execute(query, variables: variables)
      end

      it 'return correct result' do
        expect(@result['data'].deep_symbolize_keys).to eq(
          post: nil
        )
      end
    end
  end
end
