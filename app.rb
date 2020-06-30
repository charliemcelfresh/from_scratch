require 'byebug'
require 'yaml'
CONFIG = YAML::load_file(File.join(File.dirname(File.expand_path(__FILE__)), 'config.yml'))
ROUTES = CONFIG['resources']
# path, request_method, content are expressed like this in config.yml
# '/hello':
#   'GET': 'Hello!'
# will yield [200, {}, [content]]
module App
  def self.call(env)
    valid_path, response = valid_request_method = ROUTES[env['PATH_INFO']], ROUTES.dig(env['PATH_INFO'], env['REQUEST_METHOD'])
    if valid_path && valid_request_method
      [200, {}, [response]]
    else
      [404, {}, ['Not found']]
    end
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
