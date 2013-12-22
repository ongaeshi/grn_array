# -*- coding: utf-8 -*-
require_relative './grn_array'
require 'benchmark'

GrnArray.tmpdb do |array|
  native_array = []
  
  texts = File.read('dummy/dummy1.txt').split

  TEST_TIMING = [100, 1000, 10000, 100000, 1000000]
  DATA_NUM    = TEST_TIMING[-1]
  test_index = 0

  DATA_NUM.times.each do |index|
    # puts index if index % 1000 == 0
    text = texts[rand(texts.size)]
    array << {text: text}
    native_array << text

    if (array.size == TEST_TIMING[test_index])
      puts "-- #{array.size} --"
      Benchmark.bm(16) do |x|
        x.report("GrnArray#select") { 100.times { array.select("しかし") } }
        x.report("Array#grep")      { 100.times { native_array.grep(/しかし/) } }
      end
      test_index += 1
    end
  end
end
