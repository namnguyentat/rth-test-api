RSpec.shared_examples "Request succeeds" do
  let(:_current_user) { defined?(current_user) ? current_user : nil }

  before(:each) do
    raise "Parameters not defined." if !defined?(query) || !defined?(query_name) || !defined?(data)
  end

  it do
    result = AppSchema.execute(query, variables: data[:variables], context: {current_user: _current_user})
    expect(result['data'][query_name]['ret']['success']).to eq true
  end
end
