module Comment::Contract
  class Update < Reform::Form
    SETTING = Settings.contract.comment

    property :content

    validation do
      required(:content).filled(max_size?: SETTING.content_max_length)
    end
  end
end
