module Searchable
  extend ActiveSupport::Concern

  included do
    # include Elasticsearch::Model
    # TODO: switch to async callbacks
    # include Elasticsearch::Model::Callbacks

    index_name Rails.application.class.parent_name.underscore
    document_type self.name.downcase
  end
end
