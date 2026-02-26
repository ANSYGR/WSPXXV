require 'sqlite3'
require 'fileutils'

FileUtils.mkdir_p("db")
db = SQLite3::Database.new("db/app.db")

def seed!(db)
  puts "Using db file: db/app.db"
  puts "🧹 Dropping old tables..."
  drop_tables(db)
  puts "🧱 Creating tables..."
  create_tables(db)
  puts "🍎 Populating tables..."
  populate_tables(db)
  puts "✅ Done seeding!"
end

def drop_tables(db)
  db.execute("DROP TABLE IF EXISTS forum_posts")
  db.execute("DROP TABLE IF EXISTS forum_threads")
end

def create_tables(db)
  db.execute(<<~SQL)
    CREATE TABLE forum_threads (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      created_at TEXT NOT NULL
    )
  SQL

  db.execute(<<~SQL)
    CREATE TABLE forum_posts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      thread_id INTEGER NOT NULL,
      body TEXT NOT NULL,
      created_at TEXT NOT NULL,
      FOREIGN KEY(thread_id) REFERENCES forum_threads(id)
    )
  SQL

  db.execute("CREATE INDEX idx_forum_posts_thread_id ON forum_posts(thread_id)")
end

def populate_tables(db)
  db.execute("INSERT INTO forum_threads (title, created_at) VALUES (?, datetime('now'))", ["Välkommen!"])
  thread_id = db.get_first_value("SELECT last_insert_rowid()")

  db.execute("INSERT INTO forum_posts (thread_id, body, created_at) VALUES (?, ?, datetime('now'))",
             [thread_id, "Skriv första inlägget här 👋",])
end

seed!(db)