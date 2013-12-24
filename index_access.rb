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
