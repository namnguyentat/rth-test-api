class MutationResult
  attr_reader :success, :error

  def initialize(result)
    @success = !!result.try(:success?)
    @error = MutationError.new(result)
  end

  class MutationError
    attr_reader :code, :message

    def initialize(result)
      @code = result['my.error'] && result['my.error'][:code]
      @message = result['my.error'] && result['my.error'][:message]
    end
  end
end
