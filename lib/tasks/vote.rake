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

        if post.states.count > 0
          post.states.delete_all
        end

        if points.nil? || points == 0
          reposts = 0
          likes = 0
          puts "No points"
        else

          if prices[:like] == 0
            likes = 0
            reposts = points / prices[:repost]
            puts "#{points} points - All reposts = #{reposts}"
          elsif prices[:repost] == 0
            reposts = 0
            likes = points / prices[:like]
            puts "#{points} points - All likes = #{likes}"
          else

            reposts = points / prices[:repost]
            likes = ( points - reposts * prices[:repost] ) % prices[:like]

            while points != reposts * prices[:repost] + likes * prices[:like] && reposts > 0
              reposts -= 1
              likes = ( points - reposts * prices[:repost] ) / prices[:like]
            end

            puts "#{points} points - #{likes} likes and #{reposts} reposts"

          end
        end

        post.states.create likes: likes, reposts: reposts
      end
    end
  end

  task strategy_for_old: :environment do
    n = 0
    OtherVoting.all.each do |voting|
      if voting.strategy.nil?
        voting.create_strategy!
        n += 1
      end
    end
    puts "created #{n} strategies"
  end

  task voting_friendly: :environment do
    Voting.find_each(&:save)
  end
end
