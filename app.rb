require "./config/base"
class App
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

  def layout
    Tilt.new("views/application.slim")
  end

  def resource_name(env)
    env['PATH_INFO'].split("_").last.delete_prefix("/").delete_suffix("s")
  end

  def field_names(env)
    DB[resource_name(env).to_sym].columns.delete_if{|c| c.match?(/_id$/)}
  end

  def attributes(env)
    DB[resource_name(env).to_sym].attributes
  end

  def collection(env)
    collection_page = Tilt.new("views/collection.slim")
    collection = DB[resource_name(env).to_sym].all
    layout.render { collection_page.render(Object.new, collection: collection) }
  end
  
  def new(env)
    form = Tilt.new("views/new.slim")
    layout.render { form.render(self, resource_name: resource_name(env), field_names: field_names(env)) }
  end

  def create(env)
    DB[resource_name(env).to_sym].insert(Rack::Request.new(env).params)
    collection(env)
  end
end
