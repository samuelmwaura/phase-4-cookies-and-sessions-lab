class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    session[:page_views] ||= 0 #Assigns the value zero if it is the first page view i.e if oage view is nil
    session[:page_views] += 1 #If it is more than nil
    if session[:page_views] <= 3 
      article = Article.find(params[:id])
      render json: article
    else
      render json: {error: "Maximum pageview limit reached"}, status: :unauthorized
    end
  end 
  #This is a very interesting piece of code.

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end

#Cookies are stored in the user's browser and are used to excahange data from the user to the server.
#Google servers authenticates a user once whenever they visit any site within their domain. They then generate 
#a cookie for the user's browser with their authentication information. This is the reason why a user gets to gmail, youtube, 
#meet and slides and finds that they are already authenticated.
