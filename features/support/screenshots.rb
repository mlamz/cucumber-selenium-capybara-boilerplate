require 'nokogiri'
require 'base64'
require 'FileUtils'

SCREENSHOT_DIR_PATH = Dir.getwd + "/screenshots/"

AfterConfiguration do |config|
	
    if !File.exists?(SCREENSHOT_DIR_PATH)
        FileUtils.mkdir_p(SCREENSHOT_DIR_PATH)
    end
	
	Dir.glob(SCREENSHOT_DIR_PATH + "*") do | file |
		FileUtils.rm file, :force=>true
	end
end

After do |scenario|
  if (scenario.failed?)
    puts "Scenario failed at: #{page.current_url}"
    begin
      scenario_name = scenario.name.gsub!(' ', '_').gsub('\"','\'').gsub('?','-!').gsub(':','=')
    rescue
      scenario_name = "no-name"
    end
	
    @screenshot_base_name = SCREENSHOT_DIR_PATH + "screenshot-#{scenario_name}-#{Time.new.strftime("%Y-%m-%d_%H%M%S")}"
    save_screenshot()
    save_html()
  end
end

private
def save_screenshot()
  screenshot_name = "#{@screenshot_base_name}.png"

  puts "Saving screenshot #{screenshot_name}"

  File.open(screenshot_name, 'wb') do |f|
     f.write(Base64.decode64(page.driver.browser.screenshot_as(:base64)))
  end
end

private
def save_html()
   html_name = "#{@screenshot_base_name}.html"

   puts "Saving html #{html_name}"

   File.open(html_name, 'wb') do |f|
    f.write(body)
   end
end