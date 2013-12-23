require "groonga"

Groonga::Database.create(:path => "db/restore.db")
context = Groonga::Context.default
File.open("db/aozora.dump") do |dump_file|
  context.restore(dump_file)
end
