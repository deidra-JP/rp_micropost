class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  # Include default devise modules. Others available are:
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, 
         :lockable, :timeoutable, 
         :confirmable, :trackable
         #:omniauthable, omniauth_providers: [:twitter]
  def feed
    Micropost.where("user_id = ?", id)
  end       
end
