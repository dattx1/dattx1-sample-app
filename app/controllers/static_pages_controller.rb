class StaticPagesController < ApplicationController
  def home
    if logged_in?
      micropostId = params[:micropostId]
      @micropost = micropostId.blank? ? current_user.microposts.build : current_user.microposts.find_by(id: micropostId)
      @feed_items = current_user.feed.paginate page: params[:page]
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
