require 'byebug'
require 'yaml'
require 'sequel'
CONFIG = YAML::load_file(File.join(File.dirname(File.expand_path(__FILE__)), 'config.yml'))
DB = Sequel.connect(ENV['DATABASE_URL'])
ROUTES = CONFIG['resources']
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
      [JSON_CONTENT_TYPE, self.send($1)]
    else
      [TEXT_CONTENT_TYPE, r]
    end
  end

  def self.get_artists
    DB[:artist].all.to_json
  end

  def self.print_routes
    puts ROUTES.map { |path, remainder|
      remainder.map { |request_method, content|
        "#{request_method} #{path} \"#{content}\""
      }
    }.join("\n")
  end

  print_routes
end
