require_relative "_request_fail"

RSpec.shared_examples "Guests are unauthorized" do
  it_behaves_like "Request fails"
end
