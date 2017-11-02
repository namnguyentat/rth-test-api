class ClientError < Exception
  def initialize(message: nil)
    @message = JSON.parse(message).slice('file', 'func')
  end

  def to_s
    "#{@message['file']} - #{@message['func']}"
  end
end
