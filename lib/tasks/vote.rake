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
      if !voting.strategy.nil? && voting.strategy.criterions.count == 0
        voting.strategy.destroy
      end
      if voting.reload.strategy.nil?
        voting.create_strategy!
        n += 1
      end
    end
    puts "created #{n} strategies"
  end

  task voting_friendly: :environment do
    Voting.find_each(&:save)
  end

  task voters_reform: :environment do
    Social::Voter.all.each do |voter|
      state = voter.state
      post = state.post

      existing_voter = post.voters.where url: voter.url

      if existing_voter.size > 0
        voter.destroy
        state.voters.push existing_voter.first
      else
        voter.post = post
        voter.save
        state.voters.push voter
      end
    end
  end

  task vk_registed_at: :environment do
    nils_count = 0
    catch :exit do
      Social::Post::Vk.all.each do |post|
        post.voters.where( registed_at: nil ).each do |voter|
          if registed_at = post.request_registed_at( voter.url.scan(/\d+/).first )
            voter.update_attribute :registed_at, registed_at
            puts "registed_at #{registed_at}"
          else
            nils_count += 1
            if nils_count > 10
              puts 'ERROR: too many nils'
              throw :exit
            end
          end
        end
      end
    end
  end

  task member_vk: :environment do
    Strategy::Criterion::Base
    .where(type:'Strategy::Criterion::Member')
    .update_all(type:'Strategy::Criterion::MemberVk')
  end
end
