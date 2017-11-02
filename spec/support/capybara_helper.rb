module CapybaraHelper
  def t(*arg)
    I18n.t(*arg)
  end

  def l(*arg)
    I18n.l(*arg)
  end

  def have_img(uri, *args)
    have_css("img[src*='#{uri}']", *args)
  end

  def wait_until
    require "timeout"
    Timeout.timeout(Capybara.default_max_wait_time) do
      sleep(0.1) until (value = yield)
      value
    end
  end

  def wait_animation(timeout = 0.2)
    sleep(timeout)
  end

  def checkbox_value(name)
    find("input[type='checkbox'][name='#{name}']", visible: false).checked?
  end

  def check_on(name)
    page.first("input[name='#{name}']", visible: false).find(:xpath, ".//..").first(".lbl").click
  end
end
