class WhatDone < ActiveRecord::Base
  belongs_to :who, class_name: Stranger, foreign_key: 'who_id'
  belongs_to :voting, class_name: OtherVoting, foreign_key: 'voting_id'
  belongs_to :what, class_name: Action, foreign_key: 'what_id'
end
