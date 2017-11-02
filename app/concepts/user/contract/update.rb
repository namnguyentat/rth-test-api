module User::Contract
  class Update < Reform::Form
    SETTING = Settings.contract.user

    property :name
    property :about
    property :company
    property :job

    validation do
      required(:name).value(max_size?: SETTING.name_max_length)
      required(:about).value(max_size?: SETTING.about_max_length)
      optional(:company).maybe(max_size?: SETTING.company_max_length)
      optional(:job).maybe(max_size?: SETTING.job_max_length)
    end
  end
end
