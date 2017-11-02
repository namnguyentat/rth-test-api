require 'rails_helper'

RSpec.describe 'CreatePostComment', type: :graph do
  include ActiveJob::TestHelper

  let!(:user) { create(:user) }
  let!(:post) { create(:post) }
  let(:query) {
    "mutation CreatePostComment($commentable_id: GlobalIdInput!, $content: String!) {
      CreatePostComment(input: {commentable_id: $commentable_id, content: $content}) {
        ret {
          success
          error {
            code
            message
          }
        }
        comment_edge {
          node {
            commentable {
              id
            }
            user {
              id
            }
            content
          }
        }
        post {
          id
        }
      }
    }"
  }

  context 'Permission checking' do
    it_behaves_like('Login required') do
      let(:query_name) { 'CreatePostComment' }
      let(:data) { {variables: {'commentable_id' => graphql_id(post), 'content' => 'hello'}} }
    end
  end

  context 'Result checking' do
    let(:variables) { {'commentable_id' => sample_commentable_id, 'content' => sample_content} }

    context 'valid input' do
      let(:sample_commentable_id) { graphql_id(post) }
      let(:sample_content) { 'Hello' }

      before(:each) do
        @result = AppSchema.execute(query, variables: variables, context: {current_user: user})
      end

      it 'return correct result' do
        expect(@result['data']['CreatePostComment'].deep_symbolize_keys).to eq ({
          ret: {
            success: true,
            error: {
              code: nil,
              message: nil
            }
          },
          comment_edge: {
            node: {
              commentable: {
                id: graphql_id(post)
              },
              user: {
                id: graphql_id(user)
              },
              content: sample_content
            }
          },
          post: {
            id: graphql_id(post)
          }
        })
      end

      it 'comment is saved to database' do
        expect(post.comments.where(user: user, content: sample_content).count).to eq 1
      end
    end

    context 'content is blank' do
      let(:sample_commentable_id) { graphql_id(post) }
      let(:sample_content) { '' }

      before(:each) do
        @result = AppSchema.execute(query, variables: variables, context: {current_user: user})
      end

      it 'return correct result' do
        expect(@result['data']['CreatePostComment'].deep_symbolize_keys).to eq ({
          ret: {
            success: false,
            error: {
              code: Settings.error.invalid,
              message: "Content must be filled. Content size cannot be greater than #{Settings.contract.comment.content_max_length}"
            }
          },
          comment_edge: nil,
          post: nil
        })
      end

      it 'comment is not saved to the database' do
        expect(post.comments.where(user: user, content: sample_content).count).to eq 0
      end
    end

    context 'post does not exist' do
      let(:sample_commentable_id) { graphql_id(Post, 0) }
      let(:sample_content) { 'Hello' }

      before(:each) do
        @result = AppSchema.execute(query, variables: variables, context: {current_user: user})
      end

      it 'return correct result' do
        expect(@result['data']['CreatePostComment'].deep_symbolize_keys).to eq ({
          ret: {
            success: false,
            error: {
              code: Settings.error.invalid,
              message: "Commentable Id not exist"
            }
          },
          comment_edge: nil,
          post: nil
        })
      end

      it 'comment is not saved to the database' do
        expect(post.comments.where(user: user, content: sample_content).count).to eq 0
      end
    end
  end
end
