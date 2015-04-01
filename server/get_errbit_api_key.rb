require 'date'
require 'moped'
session = Moped::Session.new(['mongodb:27017'])
session.use 'errbit'
puts session[:apps].find(name: 'WonkoWeb').first[:api_key]
