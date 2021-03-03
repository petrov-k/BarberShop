require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
	return SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db
end

def is_barber_exists? base, param
	base.execute('select * from Barbers where name=?', [param]).length > 0
end

#???
def seed_db base, options
	options.each do |option|
		if !is_barber_exists? base, option
			base.execute 'insert into Barbers (name) values (?)', [option]
		end
	end
end

configure do 
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS 
		"Users" 
		(
			"Id" INTEGER PRIMARY KEY AUTOINCREMENT, 
			"username" TEXT, 
			"phone" TEXT, 
			"date_stamp" TEXT, 
			"option" TEXT, 
			"color" TEXT
		)'
	db.execute 'CREATE TABLE IF NOT EXISTS 
			"Barbers"
			(
				"Id" INTEGER PRIMARY KEY AUTOINCREMENT,
				"option" TEXT
			)'


			# seed_db db, ['a','aa','aaa']
			db.close
end


#ruby comment test

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	@error = 'something wrong!'
	erb :about
end

get '/visit' do

	erb :visit
end

post '/visit' do
	@username = params[:username]
	@phone = params[:phone]
	@date_stamp = params[:date_stamp]
	@option = params[:option]
	@color = params[:color]


	hh = {:username => 'Введите имя',
		  :phone => 'Введите телефон',
		  :date_stamp => 'Неправильная дата'}
	hh.each do |key, value|
		if params[key]==''
			@error = hh[key]
			return erb :visit
		end
	end

	db = get_db
	db.execute 'insert into 
		Users 
		(
			username, 
			phone, 
			date_stamp, 
			option, 
			color
		)
		values ( ?, ?, ?, ?, ?)', [@username, @phone, @date_stamp, @option, @color]

	@title = "Все готово!"
	@message = "#{@username}, благодарим за запись, ждем вас в #{@date_stamp}, вы записались к #{@option}"
	f = File.open './public/vizit_users.txt', 'a'
	f.write "User: #{@username}, phone: #{@phone}, date: #{@date_stamp}, option #{@option}, color: #{@color}\n"
	f.close

	erb :message
end

get '/contacts' do
	erb :contacts
end

post '/contacts' do
	@email = params[:email]
	@textmessage = params[:textmessage]
	###

	###CREATE TABLE "Cars" ("Id" INTEGER PRIMARY KEY AUTOINCREMENT, "Name" VARCHAR, "Price" INTEGER);


	if @email ==''
		@error = "Введите емеил"
		return erb :contacts
	end
	if @textmessage == ''
		@error = "Нужно ввести сообщение"
		return erb :contacts
	end
	
	@title = "Все готово!"
	@message = "Мы свяжемя с вами по этому емэйл: #{@email}"

	z = File.open './public/contacts.txt', 'a'
	z.write "Email: #{@email}, message: #{@textmessage}\n"
	z.close

	erb :message
end

get '/showusers' do
	db = get_db
	@comeonbaby = db.execute 'select * from Users order by id desc'

	erb :showusers
end



