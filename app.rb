require 'byebug'
module App
  def self.call(env)
    case env['PATH_INFO']
    when "/hello"
      [200, {}, ["Hello!"] ]
    when "/goodbye"
      [200, {}, ["Goodbye!"]]
    else
      [404, {}, ["Not Found!"]]
    end
  end
end