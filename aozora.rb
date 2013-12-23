# -*- coding: utf-8 -*-
require_relative './grn_array'
require 'find'
require 'kconv'

def read_file(filename)
  text = File.read(filename)
  Kconv.kconv(text, Kconv::UTF8).gsub("\r\n", "\n")
end

array = GrnArray.new("db/aozora.db")

if array.empty?
  # Input
  if ARGV.empty?
    puts "aozora.rb [input_dir]"
    exit
  end

  Find.find(File.expand_path ARGV[0])  do |filename|
    if File.file? filename
      array << {filename: filename, text: read_file(filename)}
    end
    puts "Input : #{array.size}" if array.size > 0 && array.size % 100 == 0
  end
  puts "Input complete : #{array.size} files"

else
  # Search
  unless ARGV.empty?
    results = array.select(ARGV.join(" "))
    puts "#{results.size} matches"
    snippet = results.snippet_text

    results.each do |record|
      puts "--- #{record.filename} ---"
      snippet.execute(record.text).each do |segment|
        puts segment.gsub("\n", "")
      end
    end
  end
end

