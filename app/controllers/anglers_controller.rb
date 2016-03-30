class AnglersController < ApplicationController
  
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
  
end