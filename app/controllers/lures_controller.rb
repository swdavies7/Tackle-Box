class LuresController < ApplicationController

  get "/lures" do
    if logged_in?
      @current_angler = current_angler
      @lures = @current_angler.lures
      erb :"/lures/lures"
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
        @error = "Please fill out the entire form and try again."
        erb :"/lures/create_lure"
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
      if @lure.tackle_box.id == @tackle_box.id && params[:name] != "" && params[:manufacturer] != ""
        @lure.update(tackle_box_id: params[:tid], name: params[:name], manufacturer: params[:manufacturer])
        @lure.save
        redirect "/tackle-boxes/#{@tackle_box.id}"
      else
        @error = "Please fill out the entire form and try again."
        erb :"/lures/edit_lure"
      end
    else
      redirect "/login"
    end
  end

end