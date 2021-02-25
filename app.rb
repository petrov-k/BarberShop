require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'


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
	@datetime = params[:datetime]
	@option = params[:option]
	@color = params[:color]


	hh = {:username => 'Введите имя',
		  :phone => 'Введите телефон',
		  :datetime => 'Неправильная дата'}
	hh.each do |key, value|
		if params[key]==''
			@error = hh[key]
			return erb :visit
		end
	end

	

	@title = "Все готово!"
	@message = "#{@username}, благодарим за запись, ждем вас в #{@datetime}, вы записались к #{@option}"
	f = File.open './public/vizit_users.txt', 'a'
	f.write "User: #{@username}, phone: #{@phone}, date: #{@datetime}, option #{@option}, color: #{@color}\n"
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