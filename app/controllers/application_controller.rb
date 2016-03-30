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
      redirect "/signup"
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

  get "/tackle-boxes" do
    if logged_in?
      @current_angler = current_angler
      erb :"/tackle_boxes/tackle_boxes"
    else
      redirect "/login"
    end
  end

  get "/tackle-boxes/new" do
    if logged_in?
      erb :"/tackle_boxes/create_tackle_box"
    else
      redirect "/login"
    end
  end

  post "/tackle-boxes/new" do
    if params[:name] == ""
      redirect "/tackle-boxes/new"
    else
      @tackle_box = TackleBox.create(name: params[:name], angler_id: current_angler.id)
      redirect "/tackle-boxes/#{@tackle_box.id}"
    end
  end

  get "/tackle-boxes/:id" do
    if logged_in?
      @tackle_box = TackleBox.find_by(id: params[:id])
      erb :"/tackle_boxes/show_tackle_box"
    else
      redirect "/login"
    end
  end

  delete "/tackle-boxes/:id/delete" do
    if logged_in?
      @tackle_box = TackleBox.find_by(id: params[:id])
      if @tackle_box.angler_id == current_angler.id
        @tackle_box.delete
      else
        redirect "/tackle-boxes"
      end
      redirect "/tackle-boxes"
    else
      redirect "/tackle-boxes"
    end
  end

  get "/tackle-boxes/:id/edit" do
    if logged_in?
      @tackle_box = TackleBox.find_by(id: params[:id])
      erb :"/tackle_boxes/edit_tackle_box"
    else
      redirect "/login"
    end
  end

  post "/tackle-boxes/:id/edit" do
    if logged_in?
      @tackle_box = TackleBox.find_by(id: params[:id])
      erb :"/tackle_boxes/edit_tackle_box"
    else
      redirect "/login"
    end
  end

  patch "/tackle-boxes/:id/edit" do
    if logged_in?
      @tackle_box = TackleBox.find_by(id: params[:id])
      if @tackle_box.angler_id == current_angler.id && params[:name] != ""
        @tackle_box.update(name: params[:name])
        @tackle_box.save
      else
        redirect "/tackle-boxes/#{@tackle_box.id}/edit"
      end
      redirect "/tackle-boxes"
    else
      redirect "/login"
    end
  end

  get "/lures" do
    if logged_in?
      @current_angler = current_angler
      @lures = @current_angler.lures
      erb :"/lures/lures"
    else
      redirect "/login"
    end
  end

  get "/anglers" do
    if logged_in?
      @anglers = Angler.all
      erb :"/anglers/anglers"
    else
      redirect "/login"
    end
  end

  get "/anglers/:slug" do
    if logged_in?
      @angler = Angler.find_by_slug(params[:slug])
      @tackle_boxes = @angler.tackle_boxes
      erb :"/anglers/show_angler"
    else
      redirect "/login"
    end
  end

  get "/tackle-boxes/:id/lures/new" do
    if logged_in?
      @tackle_box = TackleBox.find_by(id: params[:id])
      erb :"/lures/create_lure"
    else
      redirect "/login"
    end
  end

  post "/tackle-boxes/:id/lures/new" do
    if logged_in?
      @tackle_box = TackleBox.find_by(id: params[:id])
      if params[:name] == "" || params[:manufacturer] == ""
        redirect "/tackle-boxes/#{@tackle_box.id}/lures/new"
      else
        @lure = Lure.create(name: params[:name], manufacturer: params[:manufacturer], angler_id: current_angler.id, tackle_box_id: @tackle_box.id)
        redirect "/tackle-boxes/#{@tackle_box.id}"
      end
    else
      redirect "/login"
    end
  end

  get "/tackle-boxes/:id/lures/:lid" do
    if logged_in?
      @tackle_box = TackleBox.find_by(id: params[:id])
      @lure = Lure.find_by(id: params[:lid])
      erb :"/lures/show_lure"
    else
      redirect "/login"
    end
  end

  delete "/tackle-boxes/:id/lures/:lid/delete" do
    if logged_in?
      @tackle_box = TackleBox.find_by(id: params[:id])
      @lure = Lure.find_by(id: params[:lid])
      if @lure.tackle_box_id == @tackle_box.id
        @lure.delete
      else
        redirect "/tackle-boxes/#{@tackle_box.id}/lures"
      end
      redirect "/tackle-boxes/#{@tackle_box.id}/lures"
    else
      redirect "/tackle-boxes/#{@tackle_box.id}/lures"
    end
  end

  get "/tackle-boxes/:id/lures/:lid/edit" do
    if logged_in?
      @tackle_box = TackleBox.find_by(id: params[:id])
      @lure = Lure.find_by(id: params[:lid])
      erb :"/lures/edit_lure"
    else
      redirect "/login"
    end
  end

  post "/tackle-boxes/:id/lures/:lid/edit" do
    if logged_in?
      @tackle_box = TackleBox.find_by(id: params[:id])
      @lure = Lure.find_by(id: params[:lid])
      erb :"/lures/edit_lure"
    else
      redirect "/login"
    end
  end

  patch "/tackle-boxes/:id/lures/:lid/edit" do
    if logged_in?
      @tackle_box = TackleBox.find_by(id: params[:id])
      @lure = Lure.find_by(id: params[:lid])
      if @lure.tackle_box.id == @tackle_box.id && params[:name] != ""
        @lure.update(tackle_box_id: params[:tid], name: params[:name], manufacturer: params[:manufacturer])
        @lure.save
        redirect "/tackle-boxes/#{@tackle_box.id}"
      else
        redirect "/tackle-boxes/#{@tackle_box.id}/lures/#{@lure.id}/edit"
      end
      redirect "/tackle-boxes/#{@tackle_box.id}/lures"
    else
      redirect "/login"
    end
  end

  get "/tackle-boxes/:id/lures/:lid/move" do
    if logged_in?

      erb :"/lures/move_lure"
    else
      redirect "/login"
    end
  end

end