require 'flay'

desc 'Analyze the project with flog'
task :flay do
  flay = Flay.new
  flay.process Dir[Rails.root.join '{app,lib,spec}/**/*.rb']
  flay.report
end
