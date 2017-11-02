require 'rails_helper'

RSpec.describe 'UpdateUser', type: :graph do
  let(:query) {
    "mutation UpdateUser(
      $name: String!
      $about: String!
      $company: String
      $job: String
    ) {
      UpdateUser(
        input: {
          name: $name,
          about: $about
          company: $company
          job: $job
        }
      ) {
        ret {
          success
          error {
            code
            message
          }
        }
        current_user {
          name
          about
          company
          job
        }
      }
    }"
  }

  context 'Permission checking' do
    it_behaves_like('Login required') do
      let(:query_name) { 'UpdateUser' }
      let(:data) do
        {variables: {'name' => 'name', 'about' => 'about', 'company' => 'company', 'job' => 'job'}}
      end
    end
  end

  context 'Result checking' do
    let!(:user) { create(:user) }

    let(:sample_name) { "Foo" }
    let(:sample_about) { "Hello" }
    let(:sample_company) { "cool_company" }
    let(:sample_job) { "cool_job" }

    let(:variables) do
      {
        'name' => sample_name,
        'about' => sample_about,
        'company' => sample_company,
        'job' => sample_job
      }
    end

    context 'valid input' do
      before(:each) do
        @result = AppSchema.execute(query, variables: variables, context: {current_user: user})
      end

      it 'return correct result' do
        expect(@result['data']['UpdateUser'].deep_symbolize_keys).to eq(
          ret: {
            success: true,
            error: {
              code: nil,
              message: nil
            }
          },
          current_user: {
            name: sample_name,
            about: sample_about,
            company: sample_company,
            job: sample_job
          }
        )
      end

      it 'user is updated to database' do
        expect(user.name).to eq sample_name
        expect(user.about).to eq sample_about
        expect(user.company).to eq sample_company
        expect(user.job).to eq sample_job
      end
    end
  end
end
