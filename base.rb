module Base
  # path, request_method, content are expressed like this in config.yml
  # '/hello':
  #   'GET': 'Hello!'
  # will yield [200, {}, [content]]
  def call(env)
    valid_path, response = valid_request_method = ROUTES[env['PATH_INFO']], ROUTES.dig(env['PATH_INFO'], env['REQUEST_METHOD'])
    if valid_path && valid_request_method
      header, body = choose_type(response, env)
      [200, header, [body]]
    else
      [404, {}, ['Not found']]
    end
  end

  def choose_type(r, env)
    if r =~ /^\#(.*?)$/
      [HTML_CONTENT_TYPE, self.send($1, env)]
    else
      [TEXT_CONTENT_TYPE, r]
    end
  end

  def self.print_routes
    puts ROUTES.map { |path, remainder|
      remainder.map { |request_method, content|
        "#{request_method} #{path} \"#{content}\""
      }
    }.join("\n")
  end

  def layout
    Tilt.new("views/application.slim")
  end

  print_routes
end