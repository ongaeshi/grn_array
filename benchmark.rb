# -*- coding: utf-8 -*-
require_relative './grn_array'
require 'benchmark'

GrnArray.tmpdb do |array|
  native_array = []
  
  texts = File.read('dummy/dummy1.txt').split

  DATA_NUM = 1000000

  puts "-- GrnArray#select --"
  srand(0)
  DATA_NUM.times.each do |index|
    puts index if index % 1000 == 0
    text = texts[rand(texts.size)]
    array << {text: text}
  end

  p array.select("しかし").size

  Benchmark.bm(16) do |x|
    x.report("GrnArray#select") { 100.times { array.select("しかし") } }
  end

  # puts "-- Array#grep --"
  srand(0)
  DATA_NUM.times.each do |index|
    puts index if index % 1000 == 0
    text = texts[rand(texts.size)]
    native_array << text
  end

  p native_array.grep(/しかし/).size

  Benchmark.bm(16) do |x|
    x.report("Array#grep")      { 100.times { native_array.grep(/しかし/) } }
  end
end
