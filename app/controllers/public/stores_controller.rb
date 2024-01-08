class Public::StoresController < ApplicationController

  def show
    @store = Store.find(params[:id])
    @menus = @store.menus.order(created_at: :asc).first(6)
  end

end
