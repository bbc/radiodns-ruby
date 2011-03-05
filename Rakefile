require 'rake/testtask'
require 'bundler'
Bundler::GemHelper.install_tasks

task :default => [:spec]

desc "Run specs"
Rake::TestTask.new("spec") { |t|
  t.pattern = 'spec/*_spec.rb'
}
