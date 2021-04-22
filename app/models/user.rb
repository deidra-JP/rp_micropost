class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id", 
                                   dependent:   :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :follower_user, through: :passive_relationships, source: :follower
  has_many :following, through: :active_relationships,  source: :followed
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
    following << other_user
   end  
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end  
end
