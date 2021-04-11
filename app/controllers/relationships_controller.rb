class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.paginate(page: params[:page])
  end 
  
  def show
    @user = User.find(params[:id])
  end  
  
  def create
    user = User.find(params[:followed_id])
    current_user.follow(user)
    redirect_to relationships_path
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    redirect_to relationships_path
  end
end

