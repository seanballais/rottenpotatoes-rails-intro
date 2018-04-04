class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # Get settings
    if (params[:sort])
      session[:sort] = params[:sort]
    elsif (params[:ratings])
      session[:ratings] = params[:ratings]
    end
    
    # Set the settings
    @all_ratings = ["G", "NC-17", "PG", "PG-13", "R"]
    @sort_type = session[:sort] if session[:sort] else nil
    if (session[:ratings])
      @movies = Movie.where({ :rating => session[:ratings].keys })
    else
      @movies = Movie.all
    end
    
    if (@sort_type != nil)
      @movies = @movies.order(@sort_type)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
