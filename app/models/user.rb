class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  after_create :create_user_account

  has_one   :account, dependent: :destroy

  validates :email, presence: true, format: { with: /\A\S+@.+\.\S+\z/  }, uniqueness: true

  private
  
  def create_user_account
    Account.create(user_id: self.id)
  end
end
