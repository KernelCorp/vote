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

  task :snapshot, [:frequency] => :environment do |t, args|
    if args.frequency
      OtherVoting.active.where( snapshot_frequency: OtherVoting::FREQUENCY.key(args.frequency.to_sym) ).each do |voting|
        voting.social_snapshot
      end
    end
  end

  task states_for_finished: :environment do
    OtherVoting.closed.each do |voting|
      voting.social_posts.each do |post|
        prices = post.social_action.prices
        points = post.points

        if points % prices[:like] == 0
          reposts = 0
          likes = points / prices[:like]
        else

          reposts = points / prices[:repost]
          likes = ( points - reposts * prices[:repost] ) % prices[:like]

          while points != reposts * prices[:repost] + likes * prices[:like] && reposts > 0
            reposts -= 1
            likes = ( points - reposts * prices[:repost] ) / prices[:like]
          end

        end

        post.states.create likes: likes, reposts: reposts
      end
    end
  end
end
