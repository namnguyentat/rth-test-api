RSpec.shared_examples 'Unfollowable' do |klass|
  let(:factory_name) { klass.name.downcase.to_sym }
  let(:field_name) { klass.name.downcase.to_sym }
  let(:following_field_name) { "following_#{klass.name.downcase.to_sym}_count" }
  let(:following_field_name_sym) { "following_#{klass.name.downcase.to_sym}_count".to_sym }
  let!(:user) { create(:user) }
  let!(:object) { create(factory_name) }

  let(:query) {
    "mutation Unfollow#{klass.name}($id: GlobalIdInput!) {
      Unfollow#{klass.name}(input: {id: $id}) {
        ret {
          success
          error {
            code
            message
          }
        }
        #{field_name} {
          followed
          follower_count
        }
        current_user {
          #{following_field_name}
        }
      }
    }"
  }

  context 'Permission checking' do
    it_behaves_like('Login required') do
      let(:query_name) { "Unfollow#{klass.name}" }
      let(:data) { {variables: {'id' => graphql_id(object)}} }
    end
  end

  context 'Result checking' do
    let(:variables) { {'id' => sample_id} }

    context 'valid input' do
      let(:sample_id) { graphql_id(object) }

      before(:each) do
        object.followers << user
        @result = AppSchema.execute(query, variables: variables, context: {current_user: user})
      end

      it 'return correct result' do
        expect(@result['data']["Unfollow#{klass.name}"].deep_symbolize_keys).to eq(
          ret: {
            success: true,
            error: {
              code: nil,
              message: nil
            }
          },
          field_name => {
            followed: false,
            follower_count: 0
          },
          current_user: {
            following_field_name_sym => 0
          }
        )
      end

      it 'follow is removed from database' do
        expect(object.followers.where(id: user.id).count).to eq 0
      end
    end

    context "#{klass.name.downcase} is not exist" do
      let(:sample_id) { graphql_id(klass, 0) }

      before(:each) do
        object.followers << user
        @result = AppSchema.execute(query, variables: variables, context: {current_user: user})
      end

      it 'return correct result' do
        expect(@result['data']["Unfollow#{klass.name}"].deep_symbolize_keys).to eq(
          ret: {
            success: false,
            error: {
              code: Settings.error.not_exist,
              message: "Couldn't find #{klass.name}"
            }
          },
          field_name => nil,
          current_user: nil
        )
      end

      it 'follow is not removed from the database' do
        expect(object.followers.where(id: user.id).count).to eq 1
      end
    end

    context 'follow is not taken' do
      let(:sample_id) { graphql_id(object) }

      before(:each) do
        @result = AppSchema.execute(query, variables: variables, context: {current_user: user})
      end

      it 'return correct result' do
        expect(@result['data']["Unfollow#{klass.name}"].deep_symbolize_keys).to eq(
          ret: {
            success: true,
            error: {
              code: nil,
              message: nil
            }
          },
          field_name => {
            followed: false,
            follower_count: 0
          },
          current_user: {
            following_field_name_sym => 0
          }
        )
      end

      it 'follow stays the same in the database' do
        expect(object.followers.where(id: user.id).count).to eq 0
      end
    end
  end
end
