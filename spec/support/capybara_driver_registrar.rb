class CapybaraDriverRegistrar
  if ENV['SELENIUM_DEBUG'].present?
    SELENIUM_SERVER_URL = "http://selenium_chrome_standalone_debug:4444/wd/hub".freeze
  else
    SELENIUM_SERVER_URL = "http://selenium_chrome_standalone:4444/wd/hub".freeze
  end

  def self.register_selenium_local_driver(browser)
    Capybara.register_driver "selenium_#{browser}".to_sym do |app|
      Capybara::Selenium::Driver.new(app, browser: browser)
    end
  end

  def self.register_selenium_remote_driver(browser)
    Capybara.register_driver "selenium_remote_#{browser}".to_sym do |app|
      Capybara::Selenium::Driver.new(app, browser: :remote, url: SELENIUM_SERVER_URL, desired_capabilities: browser)
    end
  end
end
