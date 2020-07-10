class CustomHeader
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)

    headers['X-Charlie'] = "cwmcelfresh@gmail.com"

    [status, headers, body]
  end
end