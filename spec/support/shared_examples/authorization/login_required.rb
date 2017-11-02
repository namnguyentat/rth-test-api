require_relative "_guest_unauthorized"
require_relative "_user_authorized"

RSpec.shared_examples "Login required" do
  it_behaves_like "Guests are unauthorized"
  it_behaves_like "Users are authorized"
end
