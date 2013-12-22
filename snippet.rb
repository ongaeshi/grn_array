# -*- coding: utf-8 -*-
require_relative './grn_array'

GrnArray.tmpdb do |array|
  array << {name: 'dummy1.txt', text: File.read('dummy/dummy1.txt') }
  array << {name: 'dummy2.txt', text: File.read('dummy/dummy2.txt') }

  results = array.select('けれども')
  snippet = results.snippet_text

  results.each do |record|
    puts "--- #{record.name} ---"
    snippet.execute(record.text).each do |segment|
      puts segment.gsub("\n", "")
    end
  end
end
