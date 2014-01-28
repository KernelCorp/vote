class TextPage < ActiveRecord::Base
  SCOPES = { 0 => :for_all, 1 => :for_participants, 2 => :for_organizations }

  attr_accessible :name, :source, :scope

  extend FriendlyId
  friendly_id :name, use: :slugged

  scope :for_participants, -> { where scope: [0,1] }
  scope :for_organizations, -> { where scope: [0,2] }

  def get_related_pages
    pages = TextPage.where 'id <> ?', self.id
    return pages.merge TextPage.for_organizations if self.scope == 2
    return pages.merge TextPage.for_participants  if self.scope == 1
    pages
  end
end
