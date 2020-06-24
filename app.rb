module App
  def self.call(env)
    [200, { 'Content-Type' => 'application/json' }, ["Hello from App.call"] ]
  end
end