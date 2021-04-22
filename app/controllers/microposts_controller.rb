class MicropostsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :new, :following, :followers ]
  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to new_micropost_path
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'microposts/new'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end
  
  def new
    @micropost = current_user.microposts.build if user_signed_in?
    @feed_items = current_user.feed.paginate(page: params[:page])
  end
 
  def following
    @title = "following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'microposts/show_follow'
  end

  def follower_user
    @title = "Follower_user"
    @user  = User.find(params[:id])
    @users = @user.follower_user.paginate(page: params[:page])
    render 'microposts/show_follow'
  end
  
  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
