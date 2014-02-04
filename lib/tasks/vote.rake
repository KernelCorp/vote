namespace :vote do
  task fill_up: :environment do
    voting = OtherVoting.find 32
    unless voting.nil?
      voting.vk_posts.each do |post|
        user = post.participant
        puts "Adding #{post.result} point to #{user.fullname}"
        user.add_funds! post.result
      end
    end
  end
end