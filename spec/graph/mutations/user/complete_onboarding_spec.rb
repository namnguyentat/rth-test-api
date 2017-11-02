require 'rails_helper'

RSpec.describe 'CompleteOnboardingUser', type: :graph do
  let(:query) {
    "mutation CompleteOnboardingUser {
      CompleteOnboardingUser(input: {}) {
        ret {
          success
          error {
            code
            message
          }
        }
        current_user {
          onboarding
        }
      }
    }"
  }

  context 'Permission checking' do
    it_behaves_like('Login required') do
      let(:query_name) { 'CompleteOnboardingUser' }
      let(:data) { {variables: {}} }
    end
  end

  let!(:user) { create(:user, onboarding: 'new') }

  context 'Result checking' do
    context 'valid input' do
      before(:each) do
        @result = AppSchema.execute(query, context: {current_user: user})
      end

      it 'return correct result' do
        expect(@result['data']['CompleteOnboardingUser'].deep_symbolize_keys).to eq(
          ret: {
            success: true,
            error: {
              code: nil,
              message: nil
            }
          },
          current_user: {
            onboarding: 'completed'
          }
        )
      end

      it 'user is updated' do
        expect(user.onboarding).to eq 'completed'
      end
    end
  end
end
