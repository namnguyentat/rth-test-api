class QueriesController < ApplicationController
  def create
    result = AppSchema.execute(
      params[:query],
      variables: ensure_hash(params[:variables]),
      context: {
        current_user: current_user,
        error_notifier: (Rails.env.development? || Rails.env.test?) ?
          lambda { |e| Rails.logger.error(e) } : lambda { |e| notify_airbrake(e) }
      }
    )
    render json: result
  end

  private

  def ensure_hash(query_variables)
    if query_variables.blank?
      {}
    elsif query_variables.is_a?(String)
      JSON.parse(query_variables)
    else
      query_variables
    end
  end
end
