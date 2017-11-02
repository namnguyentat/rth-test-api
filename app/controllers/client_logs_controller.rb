class ClientLogsController < ApplicationController
  def create
    notify_airbrake(ClientError.new(message: params[:message]))
    render json: {}, status: :ok
  end
end
