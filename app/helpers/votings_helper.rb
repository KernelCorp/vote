module VotingsHelper
  def frame_for(voting)
    url = voting.is_a?(MonetaryVoting) ? voting_url(voting) : other_voting_url(voting)
"<iframe src='#{url}'  width=100% height=1024 scrolling=no frameborder=0>
<p>
Ваш браузер не поддерживает вставки страниц. Перейдите <a href=src='#{url}>по прямой ссылке</a>
</p>
</iframe>"
  end

  def voting_image_url( image, holder = nil )
    if image.path
      image.url
    elsif holder
      "http://placehold.it/#{holder}"
    end
  end

  def voting_image( image, holder = nil )
    url = voting_image_url image, holder

    if url
      "background-image: url('#{url}');"
    else
      nil
    end
  end
end
