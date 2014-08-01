#encoding: utf-8
module OtherVotingsHelper
  def label_for_participant(i, j, post)
    return "Пост удален пользователем" if post.points < 0
    if i == 0 && j == 0
      return raw( "Лидирует <br> c #{t('other_voting.show.repost_leader', count: post.points.round)}" )
    else
      return raw( "#{i*5+j+1} место <br> #{t('other_voting.show.repost',  count: post.points.round)}" )
    end
  end
  def result_for(i, j, post)
    if post.points.nil?
      return "Пост удален пользователем"
    else
      return raw( "#{i*5+j+1} место <br> #{t('other_voting.show.repost',  count: post.points.round)}")
    end
  end
end
