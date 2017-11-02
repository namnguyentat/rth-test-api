require 'rails_helper'

RSpec.describe 'ViewPost', type: :graph do
  let!(:post) { create(:post) }
  let(:query) {
    "mutation ViewPost($id: GlobalIdInput!) {
      ViewPost(input: {id: $id}) {
        ret {
          success
          error {
            code
            message
          }
        }
        post {
          view_count
        }
      }
    }"
  }

  context 'Result checking' do
    let(:variables) { {'id' => sample_id} }

    context 'valid input' do
      let(:sample_id) { graphql_id(post) }

      before(:each) do
        @result = AppSchema.execute(query, variables: variables)
      end

      it 'return correct result' do
        expect(@result['data']['ViewPost'].deep_symbolize_keys).to eq(
          ret: {
            success: true,
            error: {
              code: nil,
              message: nil
            }
          },
          post: {
            view_count: 1,
          }
        )
      end

      it 'view is saved to database' do
        expect(post.reload.view_count).to eq 1
      end
    end

    context 'post is not exist' do
      let(:sample_id) { graphql_id(Post, 0) }

      before(:each) do
        @result = AppSchema.execute(query, variables: variables)
      end

      it 'return correct result' do
        expect(@result['data']['ViewPost'].deep_symbolize_keys).to eq(
          ret: {
            success: false,
            error: {
              code: Settings.error.not_exist,
              message: "Couldn't find Post"
            }
          },
          post: nil
        )
      end

      it 'view is not saved to the database' do
        expect(post.reload.view_count).to eq 0
      end
    end
  end
end
