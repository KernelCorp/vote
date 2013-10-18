# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

rand10 = (0..9).to_a
rand100 = (0..99).to_a

organization = Organization.create({
  :email => 'cats@every.where',
  :password => 'pussycat',
  :login => 'catlover'
})
organization.save!

participant = Participant.create({
  :email => 'cats@hates.always',
  :password => 'catahater',
  :login => 'Cat_Hunter',
  :firstname => 'Hirako',
  :secondname => 'Poor'
})
participant.save!

phone = Phone.create({
  :number => [
    rand10.shuffle.first,
    rand10.shuffle.first,
    rand10.shuffle.first,
    rand10.shuffle.first,
    rand10.shuffle.first,
    rand10.shuffle.first,
    rand10.shuffle.first,
    rand10.shuffle.first,
    rand10.shuffle.first,
    rand10.shuffle.first
  ]
})
phone.participant_id = participant.id
phone.save!

voting = Voting.create({
  :name => 'Get Respectable Cat!',
  :start_date => DateTime.now
})
voting.organization_id = organization.id
voting.save!

# Maybe that not suppose to be here
voting.phone.each_with_index do |p, i|
  p.votes.each do |v|
    v.votes_count = rand100.shuffle.first
  end
end
voting.save!

claim = Claim.create({})
claim.participant_id = participant.id
claim.voting_id = voting.id
claim.phone_id = phone.id
claim.save!
