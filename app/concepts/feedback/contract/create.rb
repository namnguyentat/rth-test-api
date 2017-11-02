module Feedback::Contract
  class Create < Reform::Form
    SETTING = Settings.contract.feedback

    property :name
    property :email
    property :title
    property :content
    property :user_id

    validation do
      required(:name).filled(max_size?: SETTING.name_max_length)
      required(:email).filled(max_size?: SETTING.email_max_length)
      required(:title).filled(max_size?: SETTING.title_max_length)
      required(:content).filled(max_size?: SETTING.content_max_length)
    end
  end
end
