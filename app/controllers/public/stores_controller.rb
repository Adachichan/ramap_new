class Public::StoresController < ApplicationController

  def show
    @store = Store.find(params[:id])
    @menus = @store.menus.order(created_at: :desc).first(6)
  end

end
