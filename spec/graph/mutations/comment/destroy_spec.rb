require 'rails_helper'

RSpec.describe 'DestroyComment', type: :graph do
  let!(:user) { create(:user) }
  let!(:comment) { create(:comment, user: user) }
  let(:query) {
    "mutation DestroyComment($id: GlobalIdInput!) {
      DestroyComment(input: {id: $id}) {
        ret {
          success
          error {
            code
            message
          }
        }
        commentable {
          id
        }
      }
    }"
  }

  context 'Permission checking' do
    it_behaves_like('Ownership required') do
      let(:query_name) { 'DestroyComment' }
      let(:data) { {variables: {'id' => graphql_id(comment)}, owner: comment.user} }
    end
  end

  context 'Result checking' do
    let(:variables) { {'id' => sample_id} }

    context 'valid input' do
      let!(:sample_id) { graphql_id(comment) }

      before(:each) do
        @result = AppSchema.execute(query, variables: variables, context: {current_user: user})
      end

      it 'return correct result' do
        expect(@result['data']['DestroyComment'].deep_symbolize_keys).to eq(
          ret: {
            success: true,
            error: {
              code: nil,
              message: nil
            }
          },
          commentable: {
            id: graphql_id(comment.commentable)
          }
        )
      end

      it 'comment is removed from database' do
        expect(Comment.where(id: comment.id).count).to eq 0
      end
    end

    context 'invalid input' do
      let!(:sample_id) { graphql_id(Comment, 0) }

      before(:each) do
        @result = AppSchema.execute(query, variables: variables, context: {current_user: user})
      end

      it 'return correct result' do
        expect(@result['data']['DestroyComment'].deep_symbolize_keys).to eq(
          ret: {
            success: false,
            error: {
              code: Settings.error.not_exist,
              message: "Couldn't find Comment"
            }
          },
          commentable: nil
        )
      end

      it 'comment is not removed from the database' do
        expect(Comment.where(id: comment.id).count).to eq 1
      end
    end
  end
end
