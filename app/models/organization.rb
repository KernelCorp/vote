class Organization < User
  attr_accessible :org_name, :site, :post_address, :jur_address, :rc, :kc, :bik, :inn, :kpp, :ceo

  #statutory documents
  has_many :documents

  validates :org_name, :post_address, :jur_address, :rc, :kc, :bik, :inn, :kpp, :ceo, presence: true
  validates_format_of :rc, :kc, :bik, :inn, :kpp, with: /[0-9]+/
  validates_length_of :inn, minimum: 10, maximum: 12
  validates_length_of :rc, is: 20
  validates_length_of :kc, is: 20
  validates_length_of :bik, is: 9
  validates_length_of :kpp, is: 9

end
