class FollowsController < ApplicationController
  def create
    @store = Store.find_by(params[:store_id])
    current_user.stores << @store
    # @follow = Follow.create!(user_id: current_user.id, store_id: @store.id)
    respond_to do |format|
      format.js { render nothing: false }
      flash.now[:notice] = "Siguiendo a la tienda"
    end
  end

  def destroy
    # @follow = Follow.where(user_id: current_user.id)
    @store = Store.find_by(params[:store_id])
    # current_user.follows.find_by(params[:store_id]).destroy
    current_user.follows.find_by(store_id: @store.id).destroy
    respond_to do |format|
      format.js { render nothing: false }
      flash.now[:notice] = "Has dejado de seguir la tienda"
    end
  end
end

# current_user.stores.find_by(store_id: @store.id).destroy

# def unfollow
#   current_user.followed_users.find_by(friend_id: @user.id).destroy
#   redirect_to user_path(@user)  
# end