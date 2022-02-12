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
    @store = current_user.follows.find_by(params[:store_id])
    @store.destroy
    respond_to do |format|
      format.js { render nothing: false }
      flash.now[:notice] = "Has dejado de seguir la tienda"
    end
  end
end