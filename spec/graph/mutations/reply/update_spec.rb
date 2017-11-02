require 'rails_helper'

RSpec.describe 'UpdateReply', type: :graph do
  let!(:user) { create(:user) }
  let(:old_content) { 'old content' }
  let!(:reply) { create(:reply, user: user, content: old_content) }
  let(:query) {
    "mutation UpdateReply($id: GlobalIdInput!, $content: String!) {
      UpdateReply(input: {id: $id, content: $content}) {
        ret {
          success
          error {
            code
            message
          }
        }
        reply {
          comment {
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
      let(:query_name) { 'UpdateReply' }
      let(:data) { {variables: {'id' => graphql_id(reply), 'content' => 'hello'}, owner: user} }
    end
  end

  context 'Result checking' do
    let(:variables) { {'id' => sample_id, 'content' => new_content} }

    context 'valid input' do
      let(:sample_id) { graphql_id(reply) }
      let(:new_content) { "new content" }

      before(:each) do
        @result = AppSchema.execute(query, variables: variables, context: {current_user: user})
      end

      it 'return correct result' do
        expect(@result['data']['UpdateReply'].deep_symbolize_keys).to eq(
          ret: {
            success: true,
            error: {
              code: nil,
              message: nil
            }
          },
          reply: {
            comment: {
              id: graphql_id(reply.comment)
            },
            user: {
              id: graphql_id(user)
            },
            content: new_content
          }
        )
      end

      it 'reply is updated to database' do
        reply.reload
        expect(reply.content).to eq new_content
      end
    end

    context 'content is blank' do
      let(:sample_id) { graphql_id(reply) }
      let(:new_content) { "" }

      before(:each) do
        @result = AppSchema.execute(query, variables: variables, context: {current_user: user})
      end

      it 'return correct result' do
        expect(@result['data']['UpdateReply'].deep_symbolize_keys).to eq(
          ret: {
            success: false,
            error: {
              code: Settings.error.invalid,
              message: "Content must be filled. Content size cannot be greater than 10000"
            }
          },
          reply: nil
        )
      end

      it 'reply is not updated to the database' do
        reply.reload
        expect(reply.content).to eq old_content
      end
    end
  end
end
