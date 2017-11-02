require 'rails_helper'

RSpec.describe 'CreateReply', type: :graph do
  include ActiveJob::TestHelper

  let!(:user) { create(:user) }
  let!(:comment) { create(:comment) }
  let(:query) {
    "mutation CreateReply($comment_id: GlobalIdInput!, $content: String!) {
      CreateReply(input: {comment_id: $comment_id, content: $content}) {
        ret {
          success
          error {
            code
            message
          }
        }
        reply_edge {
          node {
            comment {
              id
            }
            user {
              id
            }
            content
          }
        }
        comment {
          id
        }
      }
    }"
  }

  context 'Permission checking' do
    it_behaves_like('Login required') do
      let(:query_name) { 'CreateReply' }
      let(:data) { {variables: {'comment_id' => graphql_id(comment), 'content' => 'hello'}} }
    end
  end

  context 'Result checking' do
    let(:variables) { {'comment_id' => sample_comment_id, 'content' => sample_content} }

    context 'valid input' do
      let(:sample_comment_id) { graphql_id(comment) }
      let(:sample_content) { 'Hello' }

      before(:each) do
        @result = AppSchema.execute(query, variables: variables, context: {current_user: user})
      end

      it 'return correct result' do
        expect(@result['data']['CreateReply'].deep_symbolize_keys).to eq ({
          ret: {
            success: true,
            error: {
              code: nil,
              message: nil
            }
          },
          reply_edge: {
            node: {
              comment: {
                id: graphql_id(comment)
              },
              user: {
                id: graphql_id(user)
              },
              content: sample_content
            }
          },
          comment: {
            id: graphql_id(comment)
          }
        })
      end

      it 'reply is saved to database' do
        expect(comment.replies.where(user: user, content: sample_content).count).to eq 1
      end

      it 'notification is created' do
        reply = comment.replies.find_by(user: user, content: sample_content)
        expect(comment.user.notifications.where(actor: user, resource: reply, action: Notification.actions[:reply_comment]).count).to eq 1
      end

      # it 'notification email sent' do
      #   expect(enqueued_jobs.select { |job| job[:queue] == 'mailers' }.size).to eq(1)
      # end
    end

    context 'content is blank' do
      let(:sample_comment_id) { graphql_id(comment) }
      let(:sample_content) { '' }

      before(:each) do
        @result = AppSchema.execute(query, variables: variables, context: {current_user: user})
      end

      it 'return correct result' do
        expect(@result['data']['CreateReply'].deep_symbolize_keys).to eq ({
          ret: {
            success: false,
            error: {
              code: Settings.error.invalid,
              message: "Content must be filled. Content size cannot be greater than #{Settings.contract.reply.content_max_length}"
            }
          },
          reply_edge: nil,
          comment: nil
        })
      end

      it 'reply is not saved to the database' do
        expect(comment.replies.where(user: user, content: sample_content).count).to eq 0
      end
    end

    context 'comment does not exist' do
      let(:sample_comment_id) { graphql_id(Comment, 0) }
      let(:sample_content) { 'Hello' }

      before(:each) do
        @result = AppSchema.execute(query, variables: variables, context: {current_user: user})
      end

      it 'return correct result' do
        expect(@result['data']['CreateReply'].deep_symbolize_keys).to eq ({
          ret: {
            success: false,
            error: {
              code: Settings.error.invalid,
              message: "Comment Id not exist"
            }
          },
          reply_edge: nil,
          comment: nil
        })
      end

      it 'reply is not saved to the database' do
        expect(comment.replies.where(user: user, content: sample_content).count).to eq 0
      end
    end
  end
end
