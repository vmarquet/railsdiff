#!/usr/bin/env ruby

# To do manually:
# create two folders with a default install

# rvm use 2.7.2  # use latest

# rvm gemset create old-rails
# rvm gemset use old-rails
# gem install rails -v X.X.X
# rails new OldRails

# rvm gemset create new-rails
# rvm gemset use new-rails
# gem install rails
# rails new NewRails


if ARGV.size < 2
  puts "Usage: #{__FILE__} old_project_dir new_project_dir"
  exit 1
end


OLD_PROJECT_PATH = ARGV[0]
NEW_PROJECT_PATH = ARGV[1]


diff = `diff -rq "#{OLD_PROJECT_PATH}" "#{NEW_PROJECT_PATH}" | grep -v 'vendor/bundle'`


diff.lines.each do |line|
  line = line.strip

  if line.end_with? ' differ'
    file1, file2 = line.split ' and '
    file1 = file1.gsub 'Files ', ''
    file2 = file2.gsub ' differ', ''

    puts "====== #{file1} ======"
    puts `diff "#{file1}" "#{file2}" | colordiff`
  elsif line.start_with? 'Only in '
    path, filename = line.split(':').map(&:strip)
    path = path.gsub 'Only in ', ''

    file = File.join path, filename
    puts "====== #{file} ======"

    if path.include? OLD_PROJECT_PATH
      puts `diff "#{file}" /dev/null | colordiff`
    else
      puts `diff /dev/null "#{file}" | colordiff`
    end
  else
    puts "Unknown line: #{line}"
  end

  puts "\n\n"
end

