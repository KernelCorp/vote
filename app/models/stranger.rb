class Stranger < ActiveRecord::Base
  attr_accessible :email, :fathersname, :firstname, :phone, :secondname

  validates :email, presence: true, uniqueness: true
  validates :phone, format: { with: /[0-9]{10}/ }, uniqueness: true, if: -> { !phone.nil? }

  has_many :done_things, class_name: WhatDone, foreign_key: 'who_id'

  def fullname
    "#{secondname} #{firstname} #{fathersname}"
  end

  def points
    points = 0
    done_things.each { |thing| points += thing.what.points }
    points
  end
end
