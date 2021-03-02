module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ArgumentError, with: :invalid_param
  end

  private

  def invalid_param(err)
    render json: {
      status: "Validation failed: #{err.message}"
    }, status: :unprocessable_entity
  end

end