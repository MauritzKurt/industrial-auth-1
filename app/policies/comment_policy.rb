class CommentPolicy < ApplicationPolicy
  attr_reader :user, :comment

  def initialize(user, comment)
    @user = user
    @comment = comment
  end

  def show?
    true
  end

  def new?
    create?
  end

  def create?
    user == comment.owner || !comment.photo.owner.private? || comment.owner.followers.include?(user)
  end

  def edit?
    user == comment.author
  end

  def update?
    edit?
  end

  def destroy?
    user == comment.author
  end
end
