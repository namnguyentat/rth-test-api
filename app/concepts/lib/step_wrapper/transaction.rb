module StepWrapper
  class Transaction
    extend Uber::Callable

    def self.call(options, *)
      ActiveRecord::Base.transaction { yield }
      true
    end
  end
end
