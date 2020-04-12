class CommentsController < ApplicationController
  def create
    @event = Event.find(params[:event_id])
    @comment = @event.comments.build(comment_params)
    @comments = @event.comments.order(created_at: :desc)
    @comment.user_id = current_user.id
    @comment.save!
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    @comment.destroy!
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :event_id, :user_id)
  end
end
