require 'flog_cli'

desc 'Analyze the project with flog'
task :flog do
  flog = FlogCLI.new continue: true, quiet: true, methods: false
  flog.flog Dir[Rails.root.join '{app,lib,spec}/**/*.rb']
  flog.report
end
