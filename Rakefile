require 'rubygems'
require 'rake'
require 'time'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rsh"
    gem.summary = %Q{Simple wrapper for rsh cli command.}
    gem.description = %Q{All freenixes (e.g. Linux, *BSD, etc.) have 'rsh' command.
      Here's the gem wrapping call to this command and handling the command's result/output.}
    gem.email = "argentoff@gmail.com"
    gem.homepage = "http://github.com/argent-smith/rsh"
    gem.authors = ["Pavel Argentov"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rsh #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc 'update changelog'  
task :changelog do  
  File.open('CHANGELOG', 'w+') do |changelog|  
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
