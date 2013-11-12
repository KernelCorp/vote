class Participant < User
  attr_accessible :firstname, :secondname, :fathersname, :phone, :birthdate, :billinfo, :age, :gender, :city

  has_many :phones, dependent: :destroy
  has_many :claims, dependent: :destroy

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
    fail ArgumentError.new 'Sum must be greater then 0' if sum < 0
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
