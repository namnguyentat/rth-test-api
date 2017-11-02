module User::Contract
  class ChangeAvatar < Reform::Form
    SETTING = Settings.contract.user

    property :avatar

    validation do
      required(:avatar).value(max_size?: SETTING.avatar_max_length)
    end
  end
end
