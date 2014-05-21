class TodoItemsController < ApplicationController
  before_action :set_todo_item, only: [:show, :edit, :update, :destroy]
  before_action :get_user

  def get_user
    @user = User.find(params[:user_id])
  end

  # GET /todo_items
  # GET /todo_items.json
  def index
    @todo_items = @user.todo_items
  end

  # GET /todo_items/1
  # GET /todo_items/1.json
  def show
    @todo_items = @user.todo_items.find(params[:id])
  end

  # GET /todo_items/new
  def new
    @todo_item = @user.todo_items.new
  end

  # GET /todo_items/1/edit
  def edit
  end

  # POST /todo_items
  # POST /todo_items.json
  def create
    @todo_item = @user.todo_items.new(todo_item_params)

    respond_to do |format|
      if @todo_item.save
        format.html { redirect_to [@user, @todo_item], 
                      notice: 'Todo item was successfully created.' }
        format.json { render action: 'show', 
                             status: :created, 
                             location: [@user, @todo_item] }
      else
        format.html { render action: 'new' }
        format.json { render json: @todo_item.errors, 
                             status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /todo_items/1
  # PATCH/PUT /todo_items/1.json
  def update
    respond_to do |format|
      if @todo_item.update(todo_item_params)
        format.html { redirect_to [@user, @todo_item], 
                      notice: 'Todo item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @todo_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todo_items/1
  # DELETE /todo_items/1.json
  def destroy
    @todo_item.destroy
    respond_to do |format|
      format.html { redirect_to user_todo_items_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo_item
      @todo_item = TodoItem.find(params[:id])
    end

    def todo_item_params 
      params.require(:todo_item).permit(:title, :deadline, :description, :status, :priority)
    end
end
