# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

rand10 = (0..9).to_a
rand100 = (0..99).to_a

organization = Organization.create(
    login: 'Jobs_Hunter',
    email:    'jobs@mail.ru',
    password: 'jobspass',

    org_name:     'Apple',
    post_address: 'post address',
    jur_address:  'address',

    rc:  '12345678901234567890',
    kc:  '12345678901234567890',
    bik: '123456789',
    inn: '1234567890',
    kpp: '123456789',
    ceo: 'Jobs'
)
organization.save

participant = Participant.create({
  :email => 'cats@hates.always',
  :password => 'catahater',
  :login => 'Cat_Hunter',
  :phone => '1234567890',
  :firstname => 'Hirako',
  :secondname => 'Poor'
})
participant.save

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
  :start_date => DateTime.now,
  :end_date => DateTime.new + 50,
  :way_to_complete => 'sum'
})
voting.organization = organization
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
