class StoresController < ApplicationController
  before_action :set_store, only: %i[ show edit update destroy follow unfollow store_follow]

  def follow
    current_user.stores << @store
    redirect_to store_path(@store)  
  end
  
  def unfollow
    current_user.stores.find_by(store_id: @store.id).destroy
    redirect_to store_path(@store)  
  end

  def store_follow
    user_id = params[:follow_id]

    if Follow.create!(user_id: user_id, store_id: @store.id)
      flash[:success] = 'Now following store'
    else
      flash[:success] = 'Not able to add store'
    end
  end

  # GET /stores or /stores.json
  def index
    @stores = Store.all

    store_ids = Follow.where(user_id: current_user.id).map(&:store_id)
    store_ids << current_user.id

    # @follower_suggestions = Store.where.not(id: store_ids)
    @follower_suggestions = Store.all

    @store = Store.find_by(params[:id])

  end

  # GET /stores/1 or /stores/1.json
  def show
    @followers = @store.follows
  end

  # GET /stores/new
  def new
    @store = Store.new
  end

  # GET /stores/1/edit
  def edit
  end

  # POST /stores or /stores.json
  def create
    @store = Store.new(store_params)

    respond_to do |format|
      if @store.save
        format.html { redirect_to store_url(@store), notice: "Store was successfully created." }
        format.json { render :show, status: :created, location: @store }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stores/1 or /stores/1.json
  def update
    respond_to do |format|
      if @store.update(store_params)
        format.html { redirect_to store_url(@store), notice: "Store was successfully updated." }
        format.json { render :show, status: :ok, location: @store }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stores/1 or /stores/1.json
  def destroy
    @store.destroy

    respond_to do |format|
      format.html { redirect_to stores_url, notice: "Store was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_store
      @store = Store.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def store_params
      params.require(:store).permit(:name)
    end
end
