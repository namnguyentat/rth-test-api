require "support/shared_contexts/log_in_as_user"
require_relative "_request_succeed"

RSpec.shared_examples "Users are authorized" do
  include_context "Log in as user"
  it_behaves_like "Request succeeds"
end
