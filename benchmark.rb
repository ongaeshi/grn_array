# -*- coding: utf-8 -*-
require_relative './grn_array'
require 'benchmark'

GrnArray.tmpdb do |array|
  native_array = []
  
  texts = []
  texts << File.read('dummy/dummy1.txt')
  texts << File.read('dummy/dummy2.txt')
  texts << File.read('dummy/dummy3.txt')

  DATA_NUM = 10000

  puts "-- GrnArray#select --"
  DATA_NUM.times.each do |index|
    puts index if index % 1000 == 0
    text = texts[rand(3)]
    array << {text: text}
  end

  Benchmark.bm(16) do |x|
    x.report("GrnArray#select") { 100.times { array.select("しかし") } }
  end

  puts "-- Array#grep --"
  DATA_NUM.times.each do |index|
    puts index if index % 1000 == 0
    text = texts[rand(3)]
    native_array << text
  end

  Benchmark.bm(16) do |x|
    x.report("Array#grep")      { 100.times { native_array.grep(/しかし/) } }
  end
end
