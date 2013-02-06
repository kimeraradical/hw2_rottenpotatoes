class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if (session[:movies_sort_column].present? && params[:sort].nil?) || (session[:movies_ratings_column].present? && params[:ratings].nil?)
      redirect_to movies_path({sort: session[:movies_sort_column], ratings: session[:movies_ratings_column]}) and return   
    end
    
    # yours implementation here
    #@movies = Movie.order(params[:sort]).all
    @sort = params[:sort]
    if @sort != nil
      session[:movies_sort_column] = @sort
    end

    @selected_ratings = params[:ratings] if params[:ratings] != nil or @selected_ratings == []
    if @selected_ratings != nil
      session[:movies_ratings_column] = @selected_ratings
      
    elsif @selected_ratings == [] or @selected_ratings == nil
      @selected_ratings = Movie.ratings
    end

    
    


    #if $selected_ratings == [] or $selected_ratings == nil
    #  $selected_ratings = Movie.ratings
    #else
    #  if params[:ratings].present?
    #    $selected_ratings = params[:ratings].keys
    #  end
    #end
    
    # flash[:notice] = "#{session[@selected_ratings]}---#{session[:movies_sort_column]}"
    
    @movies = Movie.where(:rating => (@selected_ratings)).order(@sort)
   
    #@movies = Movie.all
  end

  def new
    # default: render 'new' template
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
