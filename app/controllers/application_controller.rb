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
		erb :"index"
	end

  get "/signup" do
    if logged_in?
      redirect "/lures"
    else
		  erb :"/anglers/create_angler"
    end
	end

  post "/signup" do
    if params[:username] == "" || params[:password] == "" || params[:email] == ""
      redirect "/signup"
    else
      angler = Angler.create(username: params[:username], password: params[:password], email: params[:email])
      session[:id] = angler.id
      redirect "/lures"
    end
  end

  get "/login" do
    if logged_in?
      redirect "/lures"
    else
		  erb :"/anglers/login"
    end
	end

  post "/login" do
    angler = Angler.find_by(:username => params[:username])
    if angler && angler.authenticate(params[:password])
        session[:id] = angler.id
        redirect "/lures"
    else
        redirect "/login"
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

  get "/lures" do
    if logged_in?
      @lures = Lure.all
      @current_angler = current_angler
      erb :"/lures/lures"
    else
      redirect "/login"
    end
  end

  get "/anglers/:slug" do
    @angler = Angler.find_by_slug(params[:slug])
    @lures = @angler.lures
    erb :"/anglers/lures"
  end

  get "/lures/new" do
    if logged_in?
      erb :"/lures/create_lure"
    else
      redirect "/login"
    end
  end

  post "/lures/new" do
    if params[:content] == ""
      redirect "/lures/new"
    else
      @lure = Lure.create(content: params[:content], angler_id: current_angler.id)
      redirect "/lures/#{@lure.id}"
    end
  end

  get "/lures/:id" do
    if logged_in?
      @lure = Lure.find_by(id: params[:id])
      erb :"/lures/show_lure"
    else
      redirect "/login"
    end
  end

  delete "/lures/:id/delete" do
    if logged_in?
      @lure = Lure.find_by(id: params[:id])
      if @lure.angler_id == current_angler.id
        @lure.delete
      else
        redirect "/lures"
      end
      redirect "/lures"
    else
      redirect "/lures"
    end
  end

  get "/lures/:id/edit" do
    if logged_in?
      @lure = Lure.find_by(id: params[:id])
      erb :"/lures/edit_lure"
    else
      redirect "/login"
    end
  end
  
  post "/lures/:id/edit" do
    if logged_in?
      @lure = Lure.find_by(id: params[:id])
      erb :"/lures/edit_lure"
    else
      redirect "/login"
    end
  end

  patch "/lures/:id/edit" do
    if logged_in?
      @lure = Lure.find_by(id: params[:id])
      if @lure.angler_id == current_angler.id && params[:content] != ""
        @lure.update(content: params[:content])
        @lure.save
      else
        redirect "/lures/#{@lure.id}/edit"
      end
      redirect "/lures"
    else
      redirect "/login"
    end
  end

end