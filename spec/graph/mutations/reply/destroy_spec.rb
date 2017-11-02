require 'rails_helper'

RSpec.describe 'DestroyReply', type: :graph do
  let!(:user) { create(:user) }
  let!(:reply) { create(:reply, user: user) }
  let(:query) {
    "mutation DestroyReply($id: GlobalIdInput!) {
      DestroyReply(input: {id: $id}) {
        ret {
          success
          error {
            code
            message
          }
        }
        comment {
          id
        }
      }
    }"
  }

  context 'Permission checking' do
    it_behaves_like('Ownership required') do
      let(:query_name) { 'DestroyReply' }
      let(:data) { {variables: {'id' => graphql_id(reply)}, owner: reply.user} }
    end
  end

  context 'Result checking' do
    let(:variables) { {'id' => sample_id} }

    context 'valid input' do
      let!(:sample_id) { graphql_id(reply) }

      before(:each) do
        @result = AppSchema.execute(query, variables: variables, context: {current_user: user})
      end

      it 'return correct result' do
        expect(@result['data']['DestroyReply'].deep_symbolize_keys).to eq(
          ret: {
            success: true,
            error: {
              code: nil,
              message: nil
            }
          },
          comment: {
            id: graphql_id(reply.comment)
          }
        )
      end

      it 'reply is removed from database' do
        expect(Reply.where(id: reply.id).count).to eq 0
      end
    end

    context 'invalid input' do
      let!(:sample_id) { graphql_id(Reply, 0) }

      before(:each) do
        @result = AppSchema.execute(query, variables: variables, context: {current_user: user})
      end

      it 'return correct result' do
        expect(@result['data']['DestroyReply'].deep_symbolize_keys).to eq(
          ret: {
            success: false,
            error: {
              code: Settings.error.not_exist,
              message: "Couldn't find Reply"
            }
          },
          comment: nil
        )
      end

      it 'reply is not removed from the database' do
        expect(Reply.where(id: reply.id).count).to eq 1
      end
    end
  end
end
