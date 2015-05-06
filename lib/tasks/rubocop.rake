require 'rubocop/rake_task'

RuboCop::RakeTask.new(:rubocop) do |task|
  task.options = ['--rails']
end
