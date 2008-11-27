require 'test/unit'
require 'rubygems'
require 'mocha'

$LOAD_PATH << File.dirname(__FILE__) + "/../lib"
require 'asset_hosting_with_minimum_ssl'


class AssetHostingWithMinimumSslTest < Test::Unit::TestCase
  def setup
    @asset_host = AssetHostingWithMinimumSsl.new("http://assets%d.example.com/", "https://assets1.example.com/")
  end
  
  def test_ssl_requests_for_javascript_files_should_stay_ssl_regardless_of_the_browser
    %w( Safari Firefox IE ).each do |browser|
      assert_equal \
        ssl_host, 
        @asset_host.call("/javascripts/prototype.js", ssl_request_from(browser))
    end
  end

  def test_ssl_requests_for_anything_but_js_files_should_go_non_ssl_on_safari
    assert_match \
      non_ssl_host, 
      @asset_host.call("/images/blank.gif", ssl_request_from("Safari"))

    assert_match \
      non_ssl_host, 
      @asset_host.call("/stylesheets/application.css", ssl_request_from("Safari"))
  end
  
  def test_ssl_requests_for_image_files_should_go_non_ssl_on_firefox
    assert_match \
      non_ssl_host, 
      @asset_host.call("/images/blank.gif", ssl_request_from("Firefox"))
  end

  def test_ssl_requests_for_non_image_files_should_stay_ssl_on_firefox
    assert_match \
      ssl_host, 
      @asset_host.call("/stylesheets/application.css", ssl_request_from("Firefox"))
  end
  
  def test_ssl_requests_for_anything_should_stay_ssl_on_ie
    assert_match \
      ssl_host, 
      @asset_host.call("/stylesheets/application.css", ssl_request_from("IE"))
  end
  

  private
    def non_ssl_host
      %r|http://assets\d.example.com/|
    end
  
    def ssl_host
      "https://assets1.example.com/"
    end
  
  
    def ssl_request_from(user_agent)
      stub(:headers => { "USER_AGENT" => user_agent }, :ssl? => true)
    end
end