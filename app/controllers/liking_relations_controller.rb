class LikingRelationsController < ApplicationController

  def create
    @relation = LikingRelation.new(liking_relations_params)

    @relation.save if @relation.valid?
    redirect_to posts_path, status: :see_other
  end

  def destroy
    @relation = LikingRelation.find(params[:id])

    @relation&.destroy
    redirect_to posts_path, status: :see_other
  end

  private

  def liking_relations_params
    params.require(:liking_relation).permit(:liking_user_id, :liked_post_id)
    end
end
