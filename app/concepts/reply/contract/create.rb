module Reply::Contract
  class Create < Reform::Form
    SETTING = Settings.contract.reply

    property :content
    property :comment_id
    property :user_id

    validation do
      required(:content).filled(max_size?: SETTING.content_max_length)
      required(:comment_id).filled(exists?: Comment)
    end
  end
end
