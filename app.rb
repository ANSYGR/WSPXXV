require 'sinatra'
require 'slim'
require 'sqlite3'
require 'sinatra/reloader'
require 'bcrypt'

enable :sessions
set :public_folder, File.dirname(__FILE__) + '/public'

def get_db
  db = SQLite3::Database.new("db/app.db")
  db.results_as_hash = true
  db.execute("PRAGMA foreign_keys = ON")
  db
end

def column_exists?(db, table, column)
  columns = db.execute("PRAGMA table_info(#{table})")
  columns.any? { |col| col["name"] == column }
end

def setup_database
  db = get_db

  db.execute <<~SQL
    CREATE TABLE IF NOT EXISTS user (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL UNIQUE,
      pwd_digest TEXT NOT NULL
    )
  SQL

  db.execute <<~SQL
    CREATE TABLE IF NOT EXISTS forum_threads (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      created_at TEXT NOT NULL
    )
  SQL

  db.execute <<~SQL
    CREATE TABLE IF NOT EXISTS forum_posts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      thread_id INTEGER NOT NULL,
      body TEXT NOT NULL,
      created_at TEXT NOT NULL,
      FOREIGN KEY(thread_id) REFERENCES forum_threads(id)
    )
  SQL

  db.execute <<~SQL
    CREATE TABLE IF NOT EXISTS marketplace_items (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT NOT NULL,
      image_url TEXT,
      price REAL NOT NULL,
      user_id INTEGER NOT NULL,
      created_at TEXT NOT NULL,
      FOREIGN KEY(user_id) REFERENCES user(id)
    )
  SQL

  db.execute <<~SQL
    CREATE TABLE IF NOT EXISTS marketplace_messages (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      item_id INTEGER NOT NULL,
      sender_id INTEGER NOT NULL,
      receiver_id INTEGER NOT NULL,
      body TEXT NOT NULL,
      created_at TEXT NOT NULL,
      FOREIGN KEY(item_id) REFERENCES marketplace_items(id),
      FOREIGN KEY(sender_id) REFERENCES user(id),
      FOREIGN KEY(receiver_id) REFERENCES user(id)
    )
  SQL

  unless column_exists?(db, "forum_threads", "user_id")
    db.execute("ALTER TABLE forum_threads ADD COLUMN user_id INTEGER")
  end

  unless column_exists?(db, "forum_posts", "user_id")
    db.execute("ALTER TABLE forum_posts ADD COLUMN user_id INTEGER")
  end
end

configure do
  setup_database
end

helpers do
  def current_user
    return nil unless session[:user_id]
    db = get_db
    db.execute("SELECT * FROM user WHERE id = ?", [session[:user_id]]).first
  end

  def logged_in?
    !current_user.nil?
  end

  def require_login!
    redirect '/login?error=Du+måste+logga+in' unless logged_in?
  end
end

get '/' do
  @title = 'Home'
  slim :index
end

get '/home' do
  @title = 'Home'
  slim :index
end

get '/login' do
  @title = 'Login'
  slim :login
end

post '/login' do
  name = (params["name"] || "").strip
  pwd  = params["pwd"] || ""

  db = get_db
  user = db.execute("SELECT id, name, pwd_digest FROM user WHERE name = ?", [name]).first

  if user && BCrypt::Password.new(user["pwd_digest"]) == pwd
    session[:user_id] = user["id"]
    redirect '/forum'
  else
    redirect '/login?error=Fel+användarnamn+eller+lösenord'
  end
end

post '/user' do
  name = (params["name"] || "").strip
  pwd = params["pwd"] || ""
  pwd_confirm = params["pwd_confirm"] || ""

  if name.empty?
    redirect '/login?error=Användarnamn+saknas'
  end

  if pwd.length < 3
    redirect '/login?error=Lösenordet+måste+vara+minst+3+tecken'
  end

  if pwd != pwd_confirm
    redirect '/login?error=Lösenorden+matchar+inte'
  end

  db = get_db
  existing_user = db.execute("SELECT id FROM user WHERE name = ?", [name]).first

  if existing_user
    redirect '/login?error=Användarnamnet+är+redan+taget'
  else
    pwd_digest = BCrypt::Password.create(pwd)
    db.execute("INSERT INTO user(name, pwd_digest) VALUES(?, ?)", [name, pwd_digest])

    user = db.execute("SELECT id FROM user WHERE name = ?", [name]).first
    session[:user_id] = user["id"]

    redirect '/forum'
  end
end

get '/logout' do
  session.clear
  redirect '/'
end

get '/account' do
  require_login!
  @title = 'Mitt konto'
  db = get_db
  @user = current_user

  @threads = db.execute(<<~SQL, [@user['id']])
    SELECT t.id, t.title, t.created_at
    FROM forum_threads t
    WHERE t.user_id = ?
    ORDER BY t.created_at DESC
  SQL

  @posts = db.execute(<<~SQL, [@user['id']])
    SELECT p.id, p.body, p.created_at, t.id AS thread_id, t.title AS thread_title
    FROM forum_posts p
    JOIN forum_threads t ON p.thread_id = t.id
    WHERE p.user_id = ?
    ORDER BY p.created_at DESC
    LIMIT 50
  SQL

  @marketplace_items = db.execute(<<~SQL, [@user['id']])
    SELECT * FROM marketplace_items WHERE user_id = ? ORDER BY created_at DESC
  SQL

  @marketplace_received_messages = db.execute(<<~SQL, [@user['id']])
    SELECT mm.*, mi.title AS item_title, s.name AS sender_name
    FROM marketplace_messages mm
    JOIN marketplace_items mi ON mi.id = mm.item_id
    JOIN user s ON s.id = mm.sender_id
    WHERE mm.receiver_id = ?
    ORDER BY mm.created_at DESC
  SQL

  slim :account
end

get '/marketplace' do
  @title = 'Marketplace'
  db = get_db
  @items = db.execute(<<~SQL)
    SELECT m.*, u.name AS seller_name
    FROM marketplace_items m
    LEFT JOIN user u ON u.id = m.user_id
    ORDER BY m.created_at DESC
  SQL
  slim :marketplace
end

get '/marketplace/new' do
  require_login!
  @title = 'Lägg upp item'
  slim :'marketplace/new'
end

post '/marketplace' do
  require_login!
  title = (params['title'] || '').strip
  description = (params['description'] || '').strip
  image_url = (params['image_url'] || '').strip
  price_text = (params['price'] || '').strip

  if title.empty? || description.empty? || price_text.empty?
    redirect '/marketplace/new?error=Alla+fält+måste+fyllas+i'
  end

  price = price_text.to_f
  if price <= 0
    redirect '/marketplace/new?error=Pris+måste+vara+större+än+0'
  end

  db = get_db
  db.execute(
    'INSERT INTO marketplace_items (title, description, image_url, price, user_id, created_at) VALUES (?, ?, ?, ?, ?, datetime("now"))',
    [title, description, image_url, price, session[:user_id]]
  )
  redirect '/marketplace'
end

get '/marketplace/:id' do
  @title = 'Marketplace item'
  db = get_db
  item_id = params['id']
  @item = db.execute(<<~SQL, [item_id]).first
    SELECT m.*, u.name AS seller_name
    FROM marketplace_items m
    LEFT JOIN user u ON u.id = m.user_id
    WHERE m.id = ?
  SQL

  halt 404, 'Item hittades inte' unless @item

  @messages = []
  if logged_in?
    user_id = current_user['id']

    if user_id == @item['user_id']
      @messages = db.execute(<<~SQL, [item_id])
        SELECT mm.*, s.name AS sender_name, r.name AS receiver_name
        FROM marketplace_messages mm
        LEFT JOIN user s ON s.id = mm.sender_id
        LEFT JOIN user r ON r.id = mm.receiver_id
        WHERE mm.item_id = ?
        ORDER BY mm.created_at DESC
      SQL
    else
      @messages = db.execute(<<~SQL, [item_id, user_id, user_id])
        SELECT mm.*, s.name AS sender_name, r.name AS receiver_name
        FROM marketplace_messages mm
        LEFT JOIN user s ON s.id = mm.sender_id
        LEFT JOIN user r ON r.id = mm.receiver_id
        WHERE mm.item_id = ? AND (mm.sender_id = ? OR mm.receiver_id = ?)
        ORDER BY mm.created_at DESC
      SQL
    end
  end

  slim :'marketplace/show'
end

post '/marketplace/:id/message' do
  require_login!
  item_id = params['id']
  body = (params['body'] || '').strip
  halt 400, 'Meddelande måsta innehålla text' if body.empty?

  db = get_db
  item = db.execute('SELECT * FROM marketplace_items WHERE id = ?', [item_id]).first
  halt 404, 'Item hittades inte' unless item

  db.execute(
    'INSERT INTO marketplace_messages (item_id, sender_id, receiver_id, body, created_at) VALUES (?, ?, ?, ?, datetime("now"))',
    [item_id, session[:user_id], item['user_id'], body]
  )

  redirect "/marketplace/#{item_id}?notice=Meddelandet+skickat"
end

get '/marketplace/messages' do
  require_login!
  @title = 'Meddelanden'
  db = get_db

  @received_messages = db.execute(<<~SQL, [current_user['id']])
    SELECT mm.*, mi.title AS item_title, s.name AS sender_name
    FROM marketplace_messages mm
    JOIN marketplace_items mi ON mi.id = mm.item_id
    JOIN user s ON s.id = mm.sender_id
    WHERE mm.receiver_id = ?
    ORDER BY mm.created_at DESC
  SQL

  @sent_messages = db.execute(<<~SQL, [current_user['id']])
    SELECT mm.*, mi.title AS item_title, r.name AS receiver_name
    FROM marketplace_messages mm
    JOIN marketplace_items mi ON mi.id = mm.item_id
    JOIN user r ON r.id = mm.receiver_id
    WHERE mm.sender_id = ?
    ORDER BY mm.created_at DESC
  SQL

  slim :'marketplace/messages'
end

get '/shop' do
  @title = 'Shop'
  slim :shop
end

# FORUM

get '/forum' do
  @title = 'Forum'
  db = get_db

  @threads = db.execute(<<~SQL)
    SELECT
      t.id,
      t.title,
      t.created_at,
      u.name AS author_name,
      COUNT(p.id) AS posts_count,
      MAX(p.created_at) AS last_post_at
    FROM forum_threads t
    LEFT JOIN user u ON u.id = t.user_id
    LEFT JOIN forum_posts p ON p.thread_id = t.id
    GROUP BY t.id, t.title, t.created_at, u.name
    ORDER BY COALESCE(MAX(p.created_at), t.created_at) DESC
  SQL

  slim :forum
end

get '/forum/new' do
  require_login!
  @title = 'New thread'
  slim :"forum/new"
end

post '/forum' do
  require_login!

  title = (params[:title] || "").strip
  body  = (params[:body] || "").strip

  halt 400, "Title required" if title.empty?
  halt 400, "Body required" if body.empty?

  db = get_db

  begin
    db.transaction

    db.execute(
      "INSERT INTO forum_threads (title, user_id, created_at) VALUES (?, ?, datetime('now'))",
      [title, session[:user_id]]
    )

    thread_id = db.get_first_value("SELECT last_insert_rowid()")

    db.execute(
      "INSERT INTO forum_posts (thread_id, user_id, body, created_at) VALUES (?, ?, ?, datetime('now'))",
      [thread_id, session[:user_id], body]
    )

    db.commit
    redirect "/forum/#{thread_id}"
  rescue => e
    db.rollback rescue nil
    halt 500, e.message
  end
end

get '/forum/:id' do
  @title = 'Thread'
  id = params[:id]
  db = get_db

  @thread = db.execute(<<~SQL, [id]).first
    SELECT
      t.*,
      u.name AS author_name
    FROM forum_threads t
    LEFT JOIN user u ON u.id = t.user_id
    WHERE t.id = ?
  SQL

  halt 404, "Thread not found" unless @thread

  @posts = db.execute(<<~SQL, [id])
    SELECT
      p.*,
      u.name AS author_name
    FROM forum_posts p
    LEFT JOIN user u ON u.id = p.user_id
    WHERE p.thread_id = ?
    ORDER BY p.created_at ASC, p.id ASC
  SQL

  slim :"forum/show"
end

post '/forum/:id/reply' do
  require_login!

  id = params[:id]
  body = (params[:body] || "").strip
  halt 400, "Body required" if body.empty?

  db = get_db
  thread = db.execute("SELECT id FROM forum_threads WHERE id = ?", [id]).first
  halt 404, "Thread not found" unless thread

  db.execute(
    "INSERT INTO forum_posts (thread_id, user_id, body, created_at) VALUES (?, ?, ?, datetime('now'))",
    [id, session[:user_id], body]
  )

  redirect "/forum/#{id}"
end