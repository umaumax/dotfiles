#!/usr/bin/env ruby

require 'optparse'
require 'tty/markdown'

OptionParser.new do |opts|
  opts.on "-h", "--help" do
    exit
  end
end.parse!

if ARGV.size() == 0 then
  puts TTY::Markdown.parse(STDIN.read)
  exit
end

ARGV.each_with_index do |arg, i|
  puts TTY::Markdown.parse_file(arg)
end
