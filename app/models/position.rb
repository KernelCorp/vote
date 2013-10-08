class Position < ActiveRecord::Base
  has_many :atom_votes
end
