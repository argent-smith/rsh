require 'rubygems'
require 'rake'
require 'time'
require 'bundler/setup'

Bundler.setup :default, :development, :test

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "rsh"
  gem.summary = %Q{BSD remote shell (RFC-1282) protocol client for ruby}
  gem.description = %Q{BSD rsh(1) cli program wrapper; pure ruby remote shell client implementation.}
  gem.email = "argentoff@gmail.com"
  gem.homepage = "http://argent-smith.github.com/rsh"
  gem.authors = ["Pavel Argentov"]
  gem.extra_rdoc_files = [
    "LICENSE.rdoc",
    "CHANGELOG.rdoc",
    "README.rdoc"
  ]
  # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
end
Jeweler::GemcutterTasks.new

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.rspec_opts = "-c -f d"
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rsh #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('CHANGELOG*')
  rdoc.rdoc_files.include('LICENSE*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc 'update changelog'  
task :changelog do  
  File.open('CHANGELOG.rdoc', 'w+') do |changelog|  
    `git log -z --abbrev-commit`.split("\0").each do |commit|  
      next if commit =~ /^Merge: \d*/  
      ref, author, time, _, title, _, message = commit.split("\n", 7)  
      ref = ref[/commit ([0-9a-f]+)/, 1]  
      author = author[/Author: (.*)/, 1].strip  
      time = Time.parse(time[/Date: (.*)/, 1]).utc  
      title.strip!  
  
      changelog.puts "[#{ref} | #{time}] #{author}"  
      changelog.puts '', " * #{title}"  
      changelog.puts '', message.rstrip if message  
      changelog.puts  
    end  
  end  
end 
