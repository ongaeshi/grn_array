require_relative './grn_array'

GrnArray.tmpdb do |array| 
  array << {text:"aaaa", name: "a.txt"}
  array << {text:"BBBB", name: "b.txt"}
  array << {text:"cccc", name: "c.txt"}

  array.each do |record|
    puts id: record.id, name: record.name
  end

  # p array[0].name               # Error: id > 0
  array[1].name = "A.txt"

  puts id: array[1].id, name: array[1].name, text: array[1].text
end
