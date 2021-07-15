#!/usr/bin/env ruby

require 'fileutils'

def replace_home_path(destination)
  destination.gsub("~", Dir.home)
end

def move_file(filename, destination)
  puts "Writing dotfile #{filename} to #{destination}"

  destination = replace_home_path(destination)

  # Create necessary folders
  unless Dir.exists? destination
    FileUtils.mkdir_p destination.split('/').tap(&:pop).join('/')
  end

  # Remove first line comment
  dotfile = File.readlines(filename).drop(1)
  File.open(destination, 'w+') do |f|
    f.puts dotfile
  end
end

(Dir['**/*'] - ['sync_dots.rb']).reject {|fn| File.directory?(fn) }.each do |df|
  line = File.open(df, &:gets)

  if line.start_with? '#', '"'
    move_file(df, line.split(/"|#/).pop.strip)
  else
    puts "Dotfile #{df} does not include destination. Skipping..."
  end
end
