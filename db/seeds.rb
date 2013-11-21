# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

rand10 = (0..9).to_a
rand100 = (0..99).to_a

organization = Organization.create!(
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
    ceo: 'Jobs',

    is_confirmed: true
)

participant = Participant.create!({
  :email => 'cats@hates.always',
  :password => 'catahater',
  :login => 'Cat_Hunter',
  :phone => '1234567890',
  :firstname => 'Hirako',
  :secondname => 'Poor'
})

catlover = Participant.create!({
  email: 'cats@lover.always',
  password: 'catalover',
  phone: '1231231231',
  firstname: 'Somento',
  secondname: 'Bravado'
})

middlebrow = Participant.create!({
  email: 'just@bot.com',
  password: 'justself',
  phone: '1234123412',
  firstname: 'Gertrudo',
  secondname: 'Hitagi'
})

phones = []

[participant, catlover, middlebrow].each do |e|
  phone = Phone.new({
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
  phone.participant_id = e.id
  phone.save!
  phones << phone
end

voting = MonetaryVoting.new({
  name: 'Get Respectable Cat!',
  start_date: DateTime.now,
  end_date: DateTime.now + 50,
  way_to_complete: 'sum',
  budget: 500000,
  cost: 1,
  custom_head_color: '#d9d6d6'
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

claim = Claim.new
claim.participant_id = participant.id
claim.voting_id = voting.id
claim.phone_id = phones[0].id
claim.save!

claim_second = Claim.new
claim_second.participant_id = catlover.id
claim_second.voting_id = voting.id
claim_second.phone_id = phones[1].id
claim.save!

claim_third = Claim.new
claim_third.participant_id = middlebrow.id
claim_third.voting_id = voting.id
claim_third.phone_id = phones[2].id
claim.save!

claims = []
claims << claim << claim_second << claim_third

100.times do |i|
  pool = [1, 2, 3]
  3.times do |j|
    c = ClaimStatistic.new(claim_id: claims[j].id, place: pool.shuffle.pop )
    c[:created_at] = DateTime.now - i
    c[:updated_at] = DateTime.now - i
    c.save!
  end
end
