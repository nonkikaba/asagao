class ArticlesController < ApplicationController
  before_action :login_required, except: [:index, :show]

  def index
    @articles = Article.order(released_at: :desc)
    @articles = @articles.open_to_the_public unless current_member

    unless current_member&.administrator?
      @articles = @articles.visible
    end
  end

  def show
    articles = Article.all

    articles = articles.open_to_the_public unless current_member

    unless current_member&.administrator?
      articles  = articles.visible
    end

    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(params[:article])
    if @article.save
      redirect_to @article, notice: "ニュース記事を登録しました"
    else
      render "new"
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    @article.assign_attributes(params[:article])
    if @article.save
      redirect_to @article, notice: "ニュース記事を更新しました。"
    else
      render "edit"
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to :articles
  end
end
