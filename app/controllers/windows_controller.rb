class WindowsController < ApplicationController
  after_action :flash_clear

  def change_size
    $tracker.track(user_id, 'update Window size')

    @window = Window.new(params[:size])
    if @window.valid?
      session[:size] = @window.size
      toast :success, "ウィンドウサイズを #{@window.category} に変更しました。"
    else
      toast :error, 'サイズ変更に失敗しました。もう一度試してみてください'
    end
  end
end
