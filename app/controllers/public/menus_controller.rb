class Public::MenusController < ApplicationController

  def index
    @store = Store.find(params[:store_id])
    @menus = @store.menus.page(params[:page]).per(12)
    @menus_count = @store.menus.count
  end

end
