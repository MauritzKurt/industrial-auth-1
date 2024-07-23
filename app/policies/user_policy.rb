class UserPolicy
  attr_reader :current_user, :user

  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  def show?
    true
  end

  def liked?
    show?
  end
  
  def feed?
    user == current_user
  end

  def followers?
    show?
  end

  def following?
    show?
  end

  def discover?
    feed?
  end

  def show_photos?
    user == current_user ||
    !user.private? ||
    user.followers.include?(current_user)
  end
  
  def show_feed?
    user == current_user
  end
  def show_discover?
    show_feed?
  end
end
