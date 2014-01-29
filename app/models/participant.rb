class Participant < User
  attr_accessible :firstname, :secondname, :fathersname, :phone, :birthdate, :billinfo, :age, :gender, :city, :paid,
                  :one_time_password, :parent_id
  attr_accessor :points

  has_many :phones, dependent: :destroy
  has_many :claims, dependent: :destroy
  has_many :payments, dependent: :destroy, foreign_key: :user_id
  has_many :vote_transactions, dependent: :destroy
  has_many :vk_posts, foreign_key: :participant_id, dependent: :destroy

  has_many :unconfirmed_phones, dependent: :destroy do

    def create_and_send_sms! (options = {})
      phone = UnconfirmedPhone.create! (options) do |up|
        up.participant_id = proxy_association.owner.id
        up.confirmation_code = SecureRandom.hex 3
      end

      msg = I18n.t 'participant.phone_code.sms', code: phone.confirmation_code
        SMSMailer.send_sms '7' << phone.number, msg
      phone
    end

  end

  belongs_to :parent, class_name: 'User'

  after_create :create_phone
  validates :phone, uniqueness: true, format: { with: /^\d{10}$/ }
  validate :phone_unique, on: :create

  def self.need_password? (params)
    params[:current_password].present?
  end

  def participates? (voting)
    !self.claims.where(voting_id: voting).empty?
  end

  def fullname
    if !secondname.blank? && !firstname.blank?
      "#{secondname} #{firstname}"
    else
      "#{phone}"
    end
  end

  def role? (role)
    role == :participant
  end

  def debit! (sum)
    fail ArgumentError.new 'Sum must be greater then 0' if sum < 0
    if billinfo >= sum
      self.billinfo = billinfo - sum
      self.save!
    else
      raise Exceptions::PaymentRequiredError
    end
  end

  def generate_one_time_password!
    self.one_time_password = SecureRandom.hex(8)
    save!
  end

  protected

  def phone_unique
    errors.add(:phone, I18n::t(:phone_unique)) unless Phone.find_by_number(phone).blank?
  end

  def create_phone
    self.unconfirmed_phones.create_and_send_sms! number: self.phone unless self.phone.nil?
  end

end
