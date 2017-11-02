RSpec::Matchers.define :match_collection_schema do |_expected|
  match do |actual|
    expect(actual).to match_schema('collection')
  end

  description do
    "match the schema of collection"
  end
end
