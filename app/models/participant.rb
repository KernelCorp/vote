class Participant < User
  attr_accessible :firstname, :secondname, :fathersname, :phone, :birthdate, :billinfo, :age, :gender, :city, :paid

  has_many :phones, dependent: :destroy
  has_many :claims, dependent: :destroy
  has_many :payments, dependent: :destroy, foreign_key: :user_id

  belongs_to :parent, class_name: 'User'

  after_create :create_phone

  def self.need_password? (params)
    params[:current_password].present?
  end

  def participates?(voting)
    !self.claims.where(voting_id: voting).empty?
  end

  def fullname
    "#{firstname} #{secondname}"
  end

  def role? (role)
    role == :participant
  end

  def debit!(sum)
    if billinfo >= sum
      self.billinfo = billinfo - sum
      self.save!
    else
      raise Exceptions::PaymentRequiredError
    end
  end

  protected

  def create_phone
    self.phones.create! number: self.phone unless self.phone.nil?
  end

end
