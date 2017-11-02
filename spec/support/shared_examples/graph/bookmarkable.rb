RSpec.shared_examples 'Bookmarkable' do |klass|
  let(:factory_name) { klass.name.downcase.to_sym }
  let(:field_name) { klass.name.downcase.to_sym }
  let!(:bookmark_count_name) { "bookmark_#{klass.name.downcase.to_sym}_count" }
  let!(:bookmark_count_name_sym) { "bookmark_#{klass.name.downcase.to_sym}_count".to_sym }
  let!(:user) { create(:user) }
  let!(:object) { create(factory_name) }

  let(:query) {
    "mutation Bookmark#{klass.name}($id: GlobalIdInput!) {
      Bookmark#{klass.name}(input: {id: $id}) {
        ret {
          success
          error {
            code
            message
          }
        }
        #{field_name} {
          bookmarked
        }
        current_user {
          #{bookmark_count_name}
        }
      }
    }"
  }

  context 'Permission checking' do
    it_behaves_like('Login required') do
      let(:query_name) { "Bookmark#{klass.name}" }
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
        expect(@result['data']["Bookmark#{klass.name}"].deep_symbolize_keys).to eq(
          ret: {
            success: true,
            error: {
              code: nil,
              message: nil
            }
          },
          field_name => {
            bookmarked: true
          },
          current_user: {
            bookmark_count_name_sym => 1
          }
        )
      end

      it 'bookmark is saved to database' do
        expect(object.bookmarkers.where(id: user.id).count).to eq 1
      end
    end

    context "#{klass.name.downcase} is not exist" do
      let(:sample_id) { graphql_id(klass, 0) }

      before(:each) do
        @result = AppSchema.execute(query, variables: variables, context: {current_user: user})
      end

      it 'return correct result' do
        expect(@result['data']["Bookmark#{klass.name}"].deep_symbolize_keys).to eq(
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

      it 'bookmark is not saved to the database' do
        expect(object.bookmarkers.where(id: user.id).count).to eq 0
      end
    end

    context 'bookmark has already been taken' do
      let(:sample_id) { graphql_id(object) }

      before(:each) do
        object.bookmarkers << user
        @result = AppSchema.execute(query, variables: variables, context: {current_user: user})
      end

      it 'return correct result' do
        expect(@result['data']["Bookmark#{klass.name}"].deep_symbolize_keys).to eq(
          ret: {
            success: false,
            error: {
              code: Settings.error.invalid,
              message: "Validation failed: User has already been taken"
            }
          },
          field_name => nil,
          current_user: nil
        )
      end

      it 'bookmark is not increased in the database' do
        expect(object.bookmarkers.where(id: user.id).count).to eq 1
      end
    end
  end
end
