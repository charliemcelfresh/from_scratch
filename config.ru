require 'byebug'

# run ->(env) {[200, {}, ["Hello from stabby lambda"] ]}

# run ->() {[200, {}, ["Hello from stabby lambda"] ]}

# run lambda { |env| [200, {}, ["Hello from lambda"] ]}

# run Proc.new { [200, {}, ["Hello from Proc.new with no param"] ]}

# run proc { [200, {}, ["Hello from proc with no param"] ]}

# run Proc.new { |env| [200, {}, ["Hello from Proc.new"] ]}

# run proc { |env| [200, {}, ["Hello from proc"] ]}

# run (Class.new { def self.call(env); [200, {}, ["Hello from Class"] ] end })

# run Struct.new(:blank) { def self.call(env) [200, {}, ["Hello from struct"] ] end }

# def to_app() ->(env) {[200, {}, ["Hello from to_app"] ]} end

# define_singleton_method(:call) { |env| [200, {}, ["Hello from self"] ]; byebug }; run self

# run class Object def self.call(env) [200, {}, ["Hello from Object"]] end end; run Object

# def resp(env) [200, {}, ["Hello from curry"] ] end; run method(:resp).curry
