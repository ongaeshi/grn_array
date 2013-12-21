require_relative './grn_array'

array = GrnArray.new("db/simple.db")

if array.empty?
  array << {text:"aaaa", name: "a.txt"}
  array << {text:"BBBB", name: "b.txt"}
  array << {text:"cccc", name: "c.txt"}
end

results = array.select("bb OR cc")

results.each do |record|
  puts name: record.name, text: record.text
end




