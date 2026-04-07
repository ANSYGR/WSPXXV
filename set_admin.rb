# Ruby-skript som används för att sätta en användare som admin i SQLite-databasen. Skriptet tar en user_id som argument och uppdaterar den användarens roll till "admin". Om inget argument ges, kommer det att använda user_id 1 (Apelsin) som standard.

require 'sqlite3'

db = SQLite3::Database.new("db/app.db")
db.results_as_hash = true

user_id = ARGV[0] ? ARGV[0].to_i : 1

db.execute("UPDATE user SET role = 'admin' WHERE id = ?", [user_id])

puts "användare #{user_id} är nu admin."