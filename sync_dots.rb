#!/usr/bin/env ruby

require 'fileutils'

IGNORE_FILES = ['sync_dots.rb', 'dirs']

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

dir_mappings = File.readlines("dirs").map {|f| f.split(":").map{|s| s.chomp}}.to_h

(Dir['**/*'] - IGNORE_FILES).reject {|fn| File.directory?(fn) }.each do |df|
  if df.start_with? '_'
    root_dir = df.split('/').first
    if dir_mappings.key? root_dir
      destination = "#{dir_mappings[root_dir]}/#{df.split('/').drop(1).join('/')}"
    else
      puts "Did not find a mapping for the directory '#{df}'. Skipping..."
    end

    move_file(df, destination)
    next
  end

  line = File.open(df, &:gets)
  if line.start_with? '#', '"'
    move_file(df, line.split(/"|#/).pop.strip)
  else
    puts "Dotfile #{df} does not include destination. Skipping..."
  end
end
