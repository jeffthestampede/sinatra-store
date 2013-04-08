# gem install --version 1.3.0 sinatra
gem 'sinatra', '1.3.0'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'open-uri'
require 'json'
require 'uri'
require 'pry'
require 'net/http'

before do
  @db = SQLite3::Database.new "store.sqlite3"
  @db.results_as_hash = true
end

get '/users' do
  @rs = @db.execute('SELECT * FROM users;')
  erb :show_users
end

get '/products' do
  @rs = @db.execute("SELECT * FROM products;")
  erb :show_products
end


get '/products/search' do
  @q = params[:q]
  file = open("http://search.twitter.com/search.json?q=#{URI.escape(@q)}")
  @results = JSON.load(file.read)
  erb :search_results
end

get '/products/:id/:q' do
  q = params[:q]
  id = params[:id]
  @rs = @db.execute("SELECT * FROM products WHERE id = #{id};")
  @id = id
  @q = q
  file = open("https://www.googleapis.com/shopping/search/v1/public/products?key=AIzaSyCdQS5ii82n1TXTGvIUyAVpQtoVgBTw_dA&country=US&q=#{URI.escape(@q)}&alt=json", :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE)
  @results = JSON.load(file.read)
  # @row = db.get_first_row(sql)
  # @row = rs.first
  erb :productsdetails
end

get '/product/new' do
  erb :new_product
end

post '/product/new' do
  name = params[:product_name]
  price = params[:product_price]
  sale = params[:on_sale]
  @rs = @db.execute("INSERT INTO products ('name', 'price', 'on_sale') VALUES ('#{name}', '#{price}', '#{sale}');")
  @name = name
  @price = price
  erb :success
end

get '/products/:id/delete' do
  id = params[:id]
  @id = id
  erb :delete_product
end

post '/products/:id/delete' do
  id = params[:id]
  @id = id
  @rs = @db.execute("DELETE FROM products WHERE id = #{id};")
  erb :success
end

get '/products/:id/show_form' do
  id = params[:id]
  @id = id
  erb :update_product
end

post '/products/:id/show_form' do
  id = params[:id]
  name = params[:product_name]
  price = params[:product_price]
  sale = params[:on_sale]
  @rs = @db.execute("UPDATE products SET name='#{name}', price='#{price}', on_sale='#{sale}' WHERE id = #{id};")
  @id = id
  @name = name
  @price = price
  @sale = sale
  erb :success
end
 
get '/' do
  erb :home
end

 
 
 
 
 
 