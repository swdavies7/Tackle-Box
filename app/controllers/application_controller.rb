require './config/environment'
require "./app/models/angler"
class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
		set :session_secret, "password_security"
  end

  get "/" do
		if logged_in?
      redirect "/tackle-boxes"
    else
		  erb :"index"
    end
	end

  get "/signup" do
    if logged_in?
      redirect "/tackle-boxes"
    else
		  erb :"/anglers/create_angler"
    end
	end

  post "/signup" do
    if params[:username] == "" || params[:password] == "" || params[:email] == ""
      @error = "Please fill out the entire form and try again."
      erb :"/anglers/create_angler"
    else
      angler = Angler.create(username: params[:username], password: params[:password], email: params[:email])
      session[:id] = angler.id
      redirect "/tackle-boxes"
    end
  end

  get "/login" do
    if logged_in?
      redirect "/tackle-boxes"
    else
		  erb :"/anglers/login"
    end
	end

  post "/login" do
    angler = Angler.find_by(:username => params[:username])
    if angler && angler.authenticate(params[:password])
        session[:id] = angler.id
        redirect "/tackle-boxes"
    else
      @error = "Please fill out the entire form and try again."
        erb :"/anglers/login"
    end
  end

	get "/logout" do
    if logged_in?
      session.clear
      redirect "/login"
    else
      redirect "/"
    end
	end

	helpers do
		def logged_in?
			!!session[:id]
		end

		def current_angler
			Angler.find(session[:id])
		end
	end

end