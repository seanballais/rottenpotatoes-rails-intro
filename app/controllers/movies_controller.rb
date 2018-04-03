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
    @all_ratings = Movie.group(:rating).order(:rating).pluck(:rating)

    if (params.has_key? :sort)
      if (params[:sort] == "title")
        session[:sort] = "title"
      elsif (params[:sort] == "date")
        session[:sort] = "release_date"
      end
    else
      if (params["ratings"])
        session[:ratings] = params["ratings"].keys
      end
    end

    # Set the settings
    @sort_type = session[:sort].to_sym if session[:sort] else nil
    if (session[:ratings])
      @movies = Movie.where({ :rating => session[:ratings] })
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
