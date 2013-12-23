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
  Find.find("#{ENV["HOME"]}/Downloads/tmp/青空文庫/夏目漱石")  do |filename|
    if File.file? filename
      array << {filename: filename, text: read_file(filename)}
    end
    p array.size if array.size % 1000 == 0
  end
  puts "Input complete : #{array.size} files"
end

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
