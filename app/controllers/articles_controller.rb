class ArticlesController < ApplicationController

  before_action :find_article, only: [:edit, :show, :update, :destroy]
  before_action :require_user, except: [:index, :show]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  
  def require_same_user
    if current_user != @article.user && !current_user.admin
      flash[:danger] = "You can only edit or delete an article you created"
      redirect_to root_path
    end
  end
  
  def index
    @articles = Article.paginate(page: params[:page], per_page: 5)
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.create(article_params)
    @article.user = current_user
    if @article.save
      flash[:success] = "Article was created."
       redirect_to article_path(@article)
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    find_article
    if @article.update(article_params)
      flash[:success] = "Article was successfully updated"
       redirect_to article_path(@article)
    else
      render 'edit'
    end
  end

  def destroy
    @article.destroy
    flash[:danger] = "Article was successfully deleted"
    redirect_to articles_path
  end

  private def article_params
    params.require(:article).permit(:title, :description, category_ids:[])
  end

  private def find_article
    @article = Article.find(params[:id])
  end
end