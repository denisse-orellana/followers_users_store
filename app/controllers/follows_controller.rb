class FollowsController < ApplicationController
  def create
    @store = Store.find(params[:store_id])
    current_user.stores << @store
    respond_to do |format|
      format.js { render nothing: false }
    end
  end

  def show
    @store = Store.find(params[:store_id])
    @follow = Follow.where(store_id: @store)
  end

  def destroy
    @store = current_user.follows.find_by(params[:store_id])
    @store.destroy
    respond_to do |format|
        format.js { render nothing: false }
    end
  end
end