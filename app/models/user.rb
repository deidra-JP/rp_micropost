class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :followed, class_name:  "Relationship",
                      foreign_key: "followed_id", 
                      dependent:   :destroy
  has_many :follower, class_name:  "Relationship",
                      foreign_key: "follower_id",
                      dependent:   :destroy
  has_many :follower_user, through: :followed, source: :follower
  has_many :following_user, through: :follower,  source: :followed
  # Include default devise modules. Others available are:
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, 
         :lockable, :timeoutable, 
         :confirmable, :trackable
         #:omniauthable, omniauth_providers: [:twitter]
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end       
  
  def follow(other_user)
   unless self == other_user
    following_user << other_user
   end  
  end

  def unfollow(other_user)
    followed.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following_user.include?(other_user)
  end  
end
