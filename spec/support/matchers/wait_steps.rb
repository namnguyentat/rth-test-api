require "timeout"

module WaitSteps
  extend RSpec::Matchers::DSL

  matcher :become_true do
    match do |block|
      begin
        Timeout.timeout(Capybara.default_max_wait_time) do
          sleep(0.1) until (value = block.call)
          value
        end
      rescue Timeout::Error
        false
      end
    end

    def supports_block_expectations?
      true
    end
  end

  matcher :not_become_false do
    match do |block|
      sleep 0.5
      block.call
    end

    def supports_block_expectations?
      true
    end
  end
end
