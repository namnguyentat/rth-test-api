RSpec.shared_context 'Log in as user' do
  let!(:current_user) { defined?(user_to_log_in) ? user_to_log_in : create(:user) }
end
