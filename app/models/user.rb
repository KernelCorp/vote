class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation,
    :remember_me, :login, :avatar
  attr_accessible :current_password

  has_attached_file :avatar,
                    :styles => { :medium => "300x300>", :thumb => "100x100>" },
                    :default_url => "/images/:style/missing.png"

  validates :email, :presence => true, :uniqueness => { :case_sensitive => false }
  validates :password, :length => { :minimum => 6 }

  def self.find_first_by_auth_conditions (warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where([
        "lower(login) = :value OR lower(email) = :value OR lower(phone) = :value",
        { :value => login.downcase }
      ]).first
    else
      where(conditions).first
    end
  end
end
