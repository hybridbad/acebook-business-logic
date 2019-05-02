# frozen_string_literal: true

class PostsController < ApplicationController
  def index
    if params[:user_id] != nil
      @user = User.find(params[:user_id])
    elsif params[:username] != nil
      @user = User.find_by(username: params[:username])
    end
    @posts = Post.where("recipient_id = ?", @user.id).reverse
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
    if @post.author_id != current_user.id
      flash[:danger] = "You can't edit that post!"
      redirect_to "/#{current_user.username}"
    end
  end

  def destroy
    post = Post.find(params[:id])
    if post.author_id == current_user.id
      post.destroy
      flash[:success] = "Post deleted"
      redirect_to "/#{current_user.username}"
    end
  end

  def create
    @post = Post.create(post_params.merge(author_id: current_user.id))
    recipient = User.find(post_params[:recipient_id])
    redirect_to "/#{recipient.username}"
  end

  def update
    post = Post.find(params[:id])
    recipient = User.find(post.recipient_id)

    unless post.editable?
      flash[:danger] = "Could not edit post. Posts are only editable for 10 minutes."
      redirect_to "/#{recipient.username}" and return
    end

    if post.update(post_params.merge(recipient_id: recipient.id))
      redirect_to "/#{recipient.username}"
    else
      render "edit"
    end
  end

  private

    def post_params
      params.require(:post).permit(:message, :recipient_id)
    end
end
