RSpec.shared_examples 'Downvotatable' do |klass|
  let(:factory_name) { klass.name.downcase.to_sym }
  let(:field_name) { klass.name.downcase.to_sym }
  let!(:user) { create(:user) }
  let!(:object) { create(factory_name) }

  let(:query) {
    "mutation Downvote#{klass.name}($id: GlobalIdInput!) {
      Downvote#{klass.name}(input: {id: $id}) {
        ret {
          success
          error {
            code
            message
          }
        }
        #{field_name} {
          downvoted
        }
      }
    }"
  }

  context 'Permission checking' do
    it_behaves_like('Login required') do
      let(:query_name) { "Downvote#{klass.name}" }
      let(:data) { {variables: {'id' => graphql_id(object)}} }
    end
  end

  context 'Result checking' do
    let(:variables) { {'id' => sample_id} }

    context 'valid input' do
      let(:sample_id) { graphql_id(object) }

      before(:each) do
        @result = AppSchema.execute(query, variables: variables, context: {current_user: user})
      end

      it 'return correct result' do
        expect(@result['data']["Downvote#{klass.name}"].deep_symbolize_keys).to eq(
          ret: {
            success: true,
            error: {
              code: nil,
              message: nil
            }
          },
          field_name => {
            downvoted: true
          }
        )
      end

      it 'downvote is saved to database' do
        expect(object.downvoters.where(id: user.id).count).to eq 1
      end
    end

    context "#{klass.name.downcase} is not exist" do
      let(:sample_id) { graphql_id(klass, 0) }

      before(:each) do
        @result = AppSchema.execute(query, variables: variables, context: {current_user: user})
      end

      it 'return correct result' do
        expect(@result['data']["Downvote#{klass.name}"].deep_symbolize_keys).to eq(
          ret: {
            success: false,
            error: {
              code: Settings.error.not_exist,
              message: "Couldn't find #{klass.name}"
            }
          },
          field_name => nil
        )
      end

      it 'downvote is not saved to the database' do
        expect(object.downvoters.where(id: user.id).count).to eq 0
      end
    end

    context 'downvote has already been taken' do
      let(:sample_id) { graphql_id(object) }

      before(:each) do
        object.downvoters << user
        @result = AppSchema.execute(query, variables: variables, context: {current_user: user})
      end

      it 'return correct result' do
        expect(@result['data']["Downvote#{klass.name}"].deep_symbolize_keys).to eq(
          ret: {
            success: false,
            error: {
              code: Settings.error.invalid,
              message: "Validation failed: User has already been taken"
            }
          },
          field_name => nil
        )
      end

      it 'downvote is not increased in the database' do
        expect(object.downvoters.where(id: user.id).count).to eq 1
      end
    end
  end
end
