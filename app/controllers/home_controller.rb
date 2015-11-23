# Home Controller
class HomeController < ApplicationController
  include InitializeAction

  before_action :save_current_url, only: [:play, :search]
  after_action :flash_clear, only: [:search]

  def index
    set_user_info
    set_ranking
  end

  def coming_soon
    render layout: false
  end

  def log
  end

  def play
    @video = Video.find_by_title(params[:title])
    unless @video.present? && @video.available_on_fc2?
      toast :error, 'この動画はFC2で既に削除されているようです'
      return redirect_to root_url
    end

    set_ranking
    set_user_info
    @window = Window.new(window_size)
    create_watch_history
    render :index
  end

  def search
    get_search_conditions
    @results = Video.search(@keywords_array, @bookmarks, @duration)
    toast :warning, '検索結果が多すぎるため、一部のみ表示しています' if @results.size == 200

    SearchHis.create(keyword: @keyword,
                     favs: @bookmarks,
                     duration: @duration,
                     user_id: user_id)
    set_previous_search_condition
  end

  def report
    if Video.find_by_title(params[:title]).destroy
      toast :success, '報告を受け取りました。ご協力ありがとうございます!'
    else
      toast :error, '報告に失敗しました。もう一度試してみてください。'
    end
    redirect_to previous_page_path
  end

  private

  def create_watch_history
    if session[:previous_video_url] != @video.url
      History.create(user_id: user_id,
                     keyword: session[:keyword_re],
                     video_id: @video.id)
    end
    session[:previous_video_url] = @video.url
  end

  def get_search_conditions
    search_keyword = params[:keyword] || ''
    @keyword = (search_keyword.gsub(/(　)+/, "\s"))
    @keywords_array = @keyword.split("\s")
    @bookmarks = params[:bookmarks] || 'no'
    @duration = params[:duration] || 'no'
  end

  def set_previous_search_condition
    session[:keyword_pre] = @keyword
    session[:bookmarks_pre] = @bookmarks
    session[:duration_pre] = @duration
  end
end
