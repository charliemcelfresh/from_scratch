require 'byebug'
require 'yaml'
require 'sequel'
require 'slim'
CONFIG = YAML::load_file(File.join(File.dirname(File.expand_path(__FILE__)), 'config.yml'))
DB = Sequel.connect(ENV['DATABASE_URL'])
ROUTES = CONFIG['resources']
HTML_CONTENT_TYPE = { 'Content-Type' => 'text/html' }
JSON_CONTENT_TYPE = { 'Content-Type' => 'application/json' }
TEXT_CONTENT_TYPE = { 'Content-Type' => 'application/text' }
# path, request_method, content are expressed like this in config.yml
# '/hello':
#   'GET': 'Hello!'
# will yield [200, {}, [content]]
module App
  def self.call(env)
    valid_path, response = valid_request_method = ROUTES[env['PATH_INFO']], ROUTES.dig(env['PATH_INFO'], env['REQUEST_METHOD'])
    if valid_path && valid_request_method
      header, body = choose_type(response)
      [200, header, [body]]
    else
      [404, {}, ['Not found']]
    end
  end

  def self.choose_type(r)
    if r =~ /^\#(.*?)$/
      [HTML_CONTENT_TYPE, self.send($1)]
    else
      [TEXT_CONTENT_TYPE, r]
    end
  end

  def self.get_artists
    artist_page = Tilt.new("views/artist_page.slim")
    artists = DB[:artist].all
    layout.render { artist_page.render(Object.new, artists: artists) }
  end
  
  def self.new_artist
    artist_form = Tilt.new("views/artist_form.slim")
    layout.render { artist_form.render(self) }
  end

  def self.create_artist
  end

  def self.print_routes
    puts ROUTES.map { |path, remainder|
      remainder.map { |request_method, content|
        "#{request_method} #{path} \"#{content}\""
      }
    }.join("\n")
  end

  def self.layout
    Tilt.new("views/application.slim")
  end

  print_routes
end

