module TransactionHelper
  extend ActiveSupport::Concern

  included do
    def self.with_transaction_and_return_status
      status = nil
      ActiveRecord::Base.transaction do
        begin
          yield
          status = true
        rescue ActiveRecord::Rollback
          status = nil
        end
        raise ActiveRecord::Rollback unless status
      end
      status
    end
  end
end
