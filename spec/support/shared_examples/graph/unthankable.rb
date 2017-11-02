RSpec.shared_examples 'Unthankable' do |klass|
  let(:factory_name) { klass.name.downcase.to_sym }
  let(:field_name) { klass.name.downcase.to_sym }
  let!(:user) { create(:user) }
  let!(:object) { create(factory_name) }

  let(:query) {
    "mutation Unthank#{klass.name}($id: GlobalIdInput!) {
      Unthank#{klass.name}(input: {id: $id}) {
        ret {
          success
          error {
            code
            message
          }
        }
        #{field_name} {
          thanked
        }
      }
    }"
  }

  context 'Permission checking' do
    it_behaves_like('Login required') do
      let(:query_name) { "Unthank#{klass.name}" }
      let(:data) { {variables: {'id' => graphql_id(object)}} }
    end
  end

  context 'Result checking' do
    let(:variables) { {'id' => sample_id} }

    context 'valid input' do
      let(:sample_id) { graphql_id(object) }

      before(:each) do
        object.thankers << user
        @result = AppSchema.execute(query, variables: variables, context: {current_user: user})
      end

      it 'return correct result' do
        expect(@result['data']["Unthank#{klass.name}"].deep_symbolize_keys).to eq(
          ret: {
            success: true,
            error: {
              code: nil,
              message: nil
            }
          },
          field_name => {
            thanked: false
          }
        )
      end

      it 'thank is removed from database' do
        expect(object.thankers.where(id: user.id).count).to eq 0
      end
    end

    context "{klass.name.downcase} not exist" do
      let(:sample_id) { graphql_id(klass, 0) }

      before(:each) do
        object.thankers << user
        @result = AppSchema.execute(query, variables: variables, context: {current_user: user})
      end

      it 'return correct result' do
        expect(@result['data']["Unthank#{klass.name}"].deep_symbolize_keys).to eq(
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

      it 'thank is not removed from the database' do
        expect(object.thankers.where(id: user.id).count).to eq 1
      end
    end

    context 'thank is not taken' do
      let(:sample_id) { graphql_id(object) }

      before(:each) do
        @result = AppSchema.execute(query, variables: variables, context: {current_user: user})
      end

      it 'return correct result' do
        expect(@result['data']["Unthank#{klass.name}"].deep_symbolize_keys).to eq(
          ret: {
            success: true,
            error: {
              code: nil,
              message: nil
            }
          },
          field_name => {
            thanked: false
          }
        )
      end

      it 'thank stays the same in the database' do
        expect(object.thankers.where(id: user.id).count).to eq 0
      end
    end
  end
end
