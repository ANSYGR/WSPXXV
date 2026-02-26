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
  db
end



get '/' do
  @title = 'Home'
  slim :index
end

get '/marketplace' do
  @title = 'Marketplace'
  slim :marketplace
end


#FORUM


get '/forum' do
  @title = 'Forum'
  db = get_db
  @threads = db.execute(<<~SQL)
    SELECT
      t.id,
      t.title,
      t.created_at,
      COUNT(p.id) AS posts_count,
      MAX(p.created_at) AS last_post_at
    FROM forum_threads t
    LEFT JOIN forum_posts p ON p.thread_id = t.id
    GROUP BY t.id
    ORDER BY COALESCE(last_post_at, t.created_at) DESC
  SQL
  slim :forum
end

get '/forum/new' do
  @title = 'New thread'
  slim :"forum/new"
end

post '/forum' do
  title = (params[:title] || "").strip
  body  = (params[:body]  || "").strip

  halt 400, "Title required" if title.empty?
  halt 400, "Body required"  if body.empty?

  db = get_db
  db.transaction

  db.execute("INSERT INTO forum_threads (title, created_at) VALUES (?, datetime('now'))", [title])
  thread_id = db.get_first_value("SELECT last_insert_rowid()")

  db.execute(<<~SQL, [thread_id, body])
    INSERT INTO forum_posts (thread_id, body, created_at)
    VALUES (?, ?, datetime('now'))
  SQL

  db.commit
  redirect "/forum/#{thread_id}"
rescue => e
  db.rollback rescue nil
  halt 500, e.message
end

get '/forum/:id' do
  @title = 'Thread'
  id = params[:id]
  db = get_db

  @thread = db.execute("SELECT * FROM forum_threads WHERE id = ?", [id]).first
  halt 404, "Thread not found" unless @thread

  @posts = db.execute(<<~SQL, [id])
    SELECT * FROM forum_posts
    WHERE thread_id = ?
    ORDER BY created_at ASC
  SQL

  slim :"forum/show"
end

post '/forum/:id/reply' do
  id = params[:id]
  body = (params[:body] || "").strip
  halt 400, "Body required" if body.empty?

  db = get_db
  thread = db.execute("SELECT id FROM forum_threads WHERE id = ?", [id]).first
  halt 404, "Thread not found" unless thread

  db.execute("INSERT INTO forum_posts (thread_id, body, created_at) VALUES (?, ?, datetime('now'))", [id, body])
  redirect "/forum/#{id}"
end

get '/marketplace' do
	@title = 'Marketplace'
	slim :marketplace
end


get '/shop' do
	@title = 'Shop'
	slim :shop
end