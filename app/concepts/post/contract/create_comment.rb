module Post::Contract
  class CreateComment < Reform::Form
    SETTING = Settings.contract.comment

    property :content
    property :commentable_id
    property :commentable_type
    property :user_id

    validation do
      required(:content).filled(max_size?: SETTING.content_max_length)
      required(:commentable_id).filled(exists?: Post)
    end
  end
end
