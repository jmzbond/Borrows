class InventoriesController < ApplicationController
  before_filter :authenticate, except: [:new, :create, :destroy, :manage]

  def new
    @pagetitle = "What would you like to lend?"

    if session[:signup_email].nil?
      flash[:danger] = "Please enter your email to get started"
      redirect_to root_path
    else
      @signup_parent = Signup.find_by_email(session[:signup_email].downcase)
      if @signup_parent.tos != true || @signup_parent.streetone.blank? || @signup_parent.streettwo.blank? || @signup_parent.zipcode.blank?
        flash[:danger] = "Almost there! We just need a little more info"
        redirect_to edit_signup_path
      else
        @q = @signup_parent.inventories.ransack(params[:q])
        @inventories = @q.result.includes(:signup)
      end
    end
  end

  def manage
    @pagetitle = "Approve outstanding requests from borrowers"

    if session[:signup_email].nil?
      flash[:danger] = "Please enter your email to get started"
      redirect_to root_path
    else
      @signup_parent = Signup.find_by_email(session[:signup_email].downcase)
      if @signup_parent.tos != true || @signup_parent.streetone.blank? || @signup_parent.streettwo.blank? || @signup_parent.zipcode.blank?
        flash[:danger] = "Almost there! We just need a little more info"
        redirect_to edit_signup_path
      else
        @q = @signup_parent.inventories.ransack(params[:q])
        @inventories = @q.result.includes(:signup)
      end
    end
  end

  def create
    @pagetitle = "What would you like to lend?"

    @signup_parent = Signup.find_by_email(session[:signup_email].downcase)
    @q = @signup_parent.inventories.ransack(params[:q])
    @inventories = @q.result.includes(:signup)
    # above required because when new is re-rendered, it's actually the create action 
    
    inventory_params
    if @inventory_params.blank?
      @signup_parent.errors[:base] << "Please select at least one item to lend"
      render 'new'
    else
      @inventory_params.each do |itemlist_id, quantity|
        quantity.to_i.times do
          @signup_parent.inventories.create(itemlist_id: itemlist_id)
        end
      end
      flash[:success] = "Thank you so much! We'll be in touch when a borrower comes-a-knockin'!"
      # @signup_parent.inventories.each do |i|
      #   i.save_spreadsheet
      # end
      # InventoryMailer.upload_email(@signup_parent, items_to_be_saved).deliver
      # soon inventorymailer won't be needed if i can automate the search and everything 
      redirect_to new_inventory_path
    end
  end

  def update
    @inventory = Inventory.find(params[:id])
    @inventory.update_attributes(inventory_update_params)
    if request.referer.include? 'admin'
      redirect_to :action => 'index'
    else
      redirect_to :action => 'new'
    end
  end

  def index
    @q = Inventory.ransack(params[:q])
    @inventories = @q.result.includes(:signup)
  end

  def destroy_description
    @inventory = Inventory.find(params[:id])
    @inventory.update_attributes(description: "")
    if request.referer.include? 'admin'
      redirect_to :action => 'index'
    else
      redirect_to :action => 'new'
    end
  end

  def destroy
    @destroyed = Inventory.find(params[:id])
    Inventory.find(params[:id]).destroy
    if request.referer.include? 'admin'
      redirect_to :action => 'index'
    else
      @signup_parent = Signup.find_by_email(session[:signup_email].downcase)
      InventoryMailer.delete_email(@signup_parent, @destroyed).deliver
      redirect_to :action => 'new'
    end

    #Note currently these changes are not affecting spreadsheet!
  end

  private

    def inventory_params
      #params.require(:inventory).permit(:itemlist_id, :quantity )
      #params.permit(inventory: [{:itemlist_id => :quantity}] )
      @inventory_params = params["inventory"]
      #@inventory_params = params.permit("inventory")
      #@inventory_params = params.permit(:inventory)
      @inventory_params = @inventory_params.reject { |k, v| (v == "") || ( v == "0" ) }
    end

    def inventory_update_params
      params.require(:inventory).permit(:description)
    end
end