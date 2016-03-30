class TackleBoxesController < ApplicationController

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
      @error = "Please fill out the entire form and try again."
      erb :"/tackle_boxes/create_tackle_box"
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
        @error = "Please fill out the entire form and try again."
        erb :"/tackle_boxes/edit_tackle_box"
      end
      redirect "/tackle-boxes"
    else
      redirect "/login"
    end
  end
end