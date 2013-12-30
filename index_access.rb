# -*- coding: utf-8 -*-
require_relative './grn_array'

GrnArray.tmpdb do |array| 
  array << {text:"aaaa", name: "a.txt"}
  array << {text:"BBBB", name: "b.txt"}
  array << {text:"cccc", name: "c.txt"}

  array.each do |record|
    puts id: record.id, name: record.name
  end

  # GrnArray#[](id)
  # p array[0].name               # Error: id > 0
  array[1].name = "A.txt"

  # GrnArray#delete(id)
  array.delete(2)

  # GrnArray#delete(&block)
  array.delete do |record|
    record.name == "c.txt"
  end

  # Result
  puts "----"
  array.each do |record|
    puts id: record.id, name: record.name
  end
end

puts "==="

GrnArray.tmpdb do |array| 
  array << {text:"aaaa", number: 100}
  array << {text:"bbbb", number: 200}
  array << {text:"cccc", number: 300}

  array.each do |record|
    puts text: record.text, number: record.number
  end

  puts "----"
  array.select("number:>200").each do |record|
    puts text: record.text, number: record.number
  end
end

puts "==="

GrnArray.tmpdb do |array| 
  array << {text:"aaaa", float: 1.5}
  array << {text:"bbbb", float: 2.5}
  array << {text:"cccc", float: 3.5}

  array.each do |record|
    puts text: record.text, float: record.float
  end

  puts "----"
  array.select("float:>2.6").each do |record|
    puts text: record.text, float: record.float
  end
end

puts "==="

GrnArray.tmpdb do |array| 
  array << {text:"aaaa", timestamp: Time.at(0)} # 1970-01-01 09:00:00 +0900
  array << {text:"bbbb", timestamp: Time.at(1)} # 1970-01-01 09:00:01 +0900
  array << {text:"cccc", timestamp: Time.at(2)} # 1970-01-01 09:00:02 +0900

  array.each do |record|
    puts text: record.text, timestamp: record.timestamp
  end

  puts "----"
  array.select("timestamp:>1").each do |record|
    puts text: record.text, timestamp: record.timestamp
  end
end

puts "==="

GrnArray.tmpdb do |array| 
  array << {text:"aaaa", timestamp: Time.new(2013)} # 2013-01-01
  array << {text:"bbbb", timestamp: Time.now}
  array << {text:"cccc", timestamp: Time.new(2015)} # 2015-01-01

  array.each do |record|
    puts text: record.text, timestamp: record.timestamp
  end

  puts "----"
  time_int = Time.now.to_i + 1  # Forward 1 sec
  array.select("timestamp:>#{time_int}").each do |record|
    puts text: record.text, timestamp: record.timestamp
  end

  puts "----"
  array.select("timestamp:>=#{Time.new(2013).to_i} timestamp:<=#{Time.new(2013,12).to_i}").each do |record|
    puts text: record.text, timestamp: record.timestamp
  end
end

puts "==="

GrnArray.tmpdb do |array| 
  array << {text:"aaaa", text2: "あああ"}
  array << {text:"bbbb", text2: "いいい"}
  array << {text:"cccc", text2: "ううう"}

  array.each do |record|
    p record.attributes
  end

  puts "----"
  array.select("あ", {default_column: "text2"}).each do |record|
    p record.attributes
  end
end
