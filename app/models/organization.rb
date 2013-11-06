class Organization < User
  attr_accessible :firstname, :secondname, :fathersname,
                  :org_name, :site, :post_address,
                  :jur_address, :rc, :kc,
                  :bik, :inn, :kpp, :ceo

  #statutory documents
  has_many :documents, dependent: :destroy
  has_many :votings, dependent: :destroy

  validates_format_of :rc, :kc, :bik, :inn, :kpp, with: /[0-9]+/, allow_blank: true
  validates_length_of :inn, minimum: 10, maximum: 12, allow_blank: true
  validates_length_of :rc, is: 20, allow_blank: true
  validates_length_of :kc, is: 20, allow_blank: true
  validates_length_of :bik, is: 9, allow_blank: true
  validates_length_of :kpp, is: 9, allow_blank: true

end
