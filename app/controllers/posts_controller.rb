# frozen_string_literal: true

class PostsController < ApplicationController
  def index
    if params[:user_id] != nil
      @user = User.find(params[:user_id])
      @posts = Post.where("recipient_id = ?", @user.id).reverse
    else
      @posts = Post.all
    end
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
    if @post.author_id != current_user.id
      flash[:danger] = "You can't edit that post!"
      redirect_to "/#{current_user.id}"
    end
  end

  def destroy
    post = Post.find(params[:id])
    if post.author_id == current_user.id
      post.destroy
      flash[:success] = "Post deleted"
      redirect_to "/#{current_user.id}"
    end
  end

  def create
    logged_in_user = current_user
    params = post_params
    params[:author_id] = logged_in_user.id
    @post = Post.create(params)
    redirect_to "/#{params[:recipient_id]}"
  end

  def update
    post = Post.find(params[:id])

    unless post.editable?
      flash[:danger] = "Could not edit post. Posts are only editable for 10 minutes."
      redirect_to posts_path and return
    end

    if post.update(post_params)
      redirect_to posts_path
    else
      render "edit"
    end
  end

  private

    def post_params
      params.require(:post).permit(:message, :recipient_id)
    end
end
