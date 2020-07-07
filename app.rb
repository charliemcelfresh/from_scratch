require "./config/base"
require "./base"
module App
  extend Base
  def self.get_artists(env)
    artist_page = Tilt.new("views/artist_page.slim")
    artists = DB[:artist].all
    layout.render { artist_page.render(Object.new, artists: artists) }
  end
  
  def self.new_artist(env)
    artist_form = Tilt.new("views/artist_form.slim")
    layout.render { artist_form.render(self) }
  end

  def self.create_artist(env)
    email = Rack::Request.new(env).params["email"]
    DB[:artist].insert(email: email)
    get_artists(env)
  end
end

