namespace :graph do
  desc 'Generate schema.json'
  task schema: :environment do
    SCHEMA_DIR = Rails.root
    SCHEMA_PATH = File.join(SCHEMA_DIR, 'schema.json')

    result = JSON.pretty_generate(SchemaHelper.execute_introspection_query)
    File.write(SCHEMA_PATH, result)

    puts 'schema.json is successfully generated to rails root'
  end
end
