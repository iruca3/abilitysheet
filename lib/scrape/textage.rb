require 'capybara/poltergeist'

class Scrape::Textage
  def initialize
    @target_url = 'http://textage.cc/score/index.html?sC01B00'
    @relative_path = 'http://textage.cc/score/'
  end

  def run
    html = include_js_contents(@target_url)
    list = html.xpath('//table').xpath('//tr')
    array = []
    (10...list.size).each { |i| array.push(textage_parser(list[i])) }
    Sheet.textage(array)
  end

  private

  def textage_parser(elems)
    hash = {}
    col = elems.xpath('td')
    hash[:version] = col[0].text
    hash[:link] = @relative_path + col[1].xpath('a').first['href'].split('?').first
    hash[:title] = col[3].text
    hash
  end

  def include_js_contents(target_url)
    Capybara.register_driver :poltergeist do |app|
      parameters = { js_errors: false, timeout: 1000 }
      Capybara::Poltergeist::Driver.new(app, parameters)
    end
    Capybara.default_selector = :xpath
    session = Capybara::Session.new(:poltergeist)
    session.driver.headers = { 'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X)' }
    session.visit target_url
    Nokogiri::HTML.parse(session.html)
  end
end
