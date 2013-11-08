class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation,
                  :remember_me, :login, :avatar, :current_password, :phone, :is_confirmed

  has_attached_file :avatar,
                    :styles => { medium: "300x300>", thumb: "100x100>" },
                    :default_url => "/images/:style/missing.png"

  validates :password, :length => { :minimum => 6 }, :on => :create
  validates :password, :length => { :minimum => 6 }, :on => :update, :allow_blank => true

  has_many :payments

  def self.find_first_by_auth_conditions (warden_conditions)
    conditions = warden_conditions.dup
    return nil if conditions[:login].nil?
    if login = conditions.delete(:login)
      where(conditions).where([
        "lower(email) = :value OR lower(phone) = :value",
        { :value => login.downcase }
      ]).first
    else
      where(conditions).first
    end
  end

  def email_required?
    false
  end


end
