module OtherVotingsHelper
  def label_for_participant(i, j, post)
    return "Пост удален пользователем" if post.points < 0
    if i == 0 && j == 0
      return raw( "Лидирует <br> c #{t('other_voting.show.repost_leader', count: post.points)}" )
    else
      return raw( "#{i*5+j+1} место <br> #{t('other_voting.show.repost',  count: post.points)}" )
    end
  end
end
