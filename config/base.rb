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
