class MoviesController < ApplicationController

  def show
    id = params[:id]
    @movie = Movie.find(id)
  end

  def index
    filters = {:sort => "", :ratings => {}}
    redirect = false
    filters.each do |filter, default|
      if params[filter].blank?
        if !session[filter].blank?
          redirect = true
          params[filter] = session[filter]
        else
          params[filter] = default
        end
      end
      session[filter] = params[filter]
    end
    redirect_to movies_path(:sort => params[:sort], :ratings => params[:ratings]) if redirect

    @all_ratings = Movie.ratings
    
    @movies = Movie.filtered(params)
  end

  def new
    session.clear
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
