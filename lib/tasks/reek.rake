require 'reek/rake/task'

Reek::Rake::Task.new do |t|
  t.source_files = '{app,lib,spec}/**/*.rb'
end
