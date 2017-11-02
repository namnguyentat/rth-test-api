module Post::Contract
  class Create < Reform::Form
    SETTING = Settings.contract.feedback

    property :title
    property :content
    property :user_id

    validation do
      required(:title).filled(max_size?: SETTING.title_max_length)
      required(:content).filled(max_size?: SETTING.content_max_length)
    end
  end
end
