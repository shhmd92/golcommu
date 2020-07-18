class CommentsController < ApplicationController
  def create
    @event = Event.find(params[:event_id])
    @comment = @event.comments.build(comment_params)
    @comments = @event.comments.order(created_at: :desc)
    @comment.user_id = current_user.id
    respond_to do |format|
      if @comment.save
        format.html { redirect_to request.referer || root_url }
        format.js
      else
        format.html { redirect_to @event }
      end
    end
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    @comment.destroy!
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :event_id, :user_id)
  end
end
