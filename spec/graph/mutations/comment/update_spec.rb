require 'rails_helper'

RSpec.describe 'UpdateComment', type: :graph do
  let!(:user) { create(:user) }
  let(:old_content) { 'old content' }
  let!(:comment) { create(:comment, user: user, content: old_content) }
  let(:query) {
    "mutation UpdateComment($id: GlobalIdInput!, $content: String!) {
      UpdateComment(input: {id: $id, content: $content}) {
        ret {
          success
          error {
            code
            message
          }
        }
        comment {
          commentable {
            id
          }
          user {
            id
          }
          content
        }
      }
    }"
  }

  context 'Permission checking' do
    it_behaves_like('Ownership required') do
      let(:query_name) { 'UpdateComment' }
      let(:data) { {variables: {'id' => graphql_id(comment), 'content' => 'hello'}, owner: user} }
    end
  end

  context 'Result checking' do
    let(:variables) { {'id' => sample_id, 'content' => new_content} }

    context 'valid input' do
      let(:sample_id) { graphql_id(comment) }
      let(:new_content) { "new content" }

      before(:each) do
        @result = AppSchema.execute(query, variables: variables, context: {current_user: user})
      end

      it 'return correct result' do
        expect(@result['data']['UpdateComment'].deep_symbolize_keys).to eq(
          ret: {
            success: true,
            error: {
              code: nil,
              message: nil
            }
          },
          comment: {
            commentable: {
              id: graphql_id(comment.commentable)
            },
            user: {
              id: graphql_id(user)
            },
            content: new_content
          }
        )
      end

      it 'comment is updated to database' do
        comment.reload
        expect(comment.content).to eq new_content
      end
    end

    context 'content is blank' do
      let(:sample_id) { graphql_id(comment) }
      let(:new_content) { "" }

      before(:each) do
        @result = AppSchema.execute(query, variables: variables, context: {current_user: user})
      end

      it 'return correct result' do
        expect(@result['data']['UpdateComment'].deep_symbolize_keys).to eq(
          ret: {
            success: false,
            error: {
              code: Settings.error.invalid,
              message: "Content must be filled. Content size cannot be greater than 10000"
            }
          },
          comment: nil
        )
      end

      it 'comment is not updated to the database' do
        comment.reload
        expect(comment.content).to eq old_content
      end
    end
  end
end
