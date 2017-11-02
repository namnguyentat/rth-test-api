require_relative "_guest_unauthorized"
require_relative "_request_fail"
require_relative "_request_succeed"

RSpec.shared_examples "Ownership required" do
  it_behaves_like "Guests are unauthorized"

  # context "log in as user" do
  #   context "user is not owner" do
  #     include_context "Log in as user"
  #     it_behaves_like "Request fails"
  #   end
  #
  #   context "user is owner" do
  #     include_context("Log in as user") { let(:user_to_log_in) { data[:owner] } }
  #     it_behaves_like "Request succeeds"
  #   end
  # end
end
