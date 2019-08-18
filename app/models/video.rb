class Video < ApplicationRecord
  acts_as_paranoid

  has_many :favs, dependent: :destroy
  has_many :histories
  has_many :monthly_ranks, dependent: :destroy
  has_many :weekly_ranks, dependent: :destroy
  has_many :new_arrivals, dependent: :destroy
  validates :title, presence: true
  validates :url, presence: true
  validates :views, presence: true
  validates :duration, presence: true
  validates :image_url, presence: true
  validates :bookmarks, presence: true
  validates :adult, inclusion: { in: [true, false] }
  validates :morethan100min, inclusion: { in: [true, false] }

  scope :title_is, ->(keywords) {
    sql = (['(title LIKE ?)'] * keywords.length).join(' AND ')
    where(sql[1..sql.length - 2], *keywords.map { |k| "%#{k}%" })
  }

  scope :bookmarks_is, ->(condition) {
    case condition
    when 's'
      where(bookmarks: 30..500)
    when 'm'
      where(bookmarks: 500..2000)
    when 'l'
      where { bookmarks >= 2000 }
    end
  }

  scope :duration_is, ->(condition) {
    case condition
    when 's'
      where(duration: '00:00'..'10:00').where(morethan100min: 0)
    when 'm'
      where(duration: '10:00'..'30:00').where(morethan100min: 0)
    when 'l'
      where(duration: '30:00'..'60:00').where(morethan100min: 0)
    when 'xl'
      where("duration >= '60:00' or morethan100min = 1")
    end
  }

  scope :search, ->(keywords, bookmarks, duration) {
    title_is(keywords)
      .bookmarks_is(bookmarks)
      .duration_is(duration)
      .order('bookmarks DESC')
      .limit(SEARCH_LIMIT)
  }

  def available_on_fc2?
    Fc2.new(url).available?
  end

  # プレイヤーで参照するURL
  def ref_url
    url.split('/').last
  end

  def duration_sec
    min, sec = duration.split(':').map(&:to_i)
    min * 60 + sec
  end

  class << self
    # 毎日1→3000ページ(150000動画)を更新
    def daily_update
      Fc2.scrape('adult', 1, 3000)
      Fc2.scrape('normal', 1, 1500)
      NewArrival.update
    end

    def weekly_rank
      list_of(WeeklyRank.all.limit(100))
    end

    def monthly_rank
      list_of(MonthlyRank.all.limit(100))
    end

    def user_histories(user_id)
      list_of(History.list(user_id))
    end

    def list_of(records)
      video_ids = records.each_with_object([]) do |r, ids|
        ids << r.video_id
      end
      query = ApplicationRecord.send(:sanitize_sql_array,
                                      ['field(id ,?)', video_ids])
      Video.where(id: video_ids).order(query)
    end

    def new_arrivals_list
      rcmd_videos_size = NewArrival.order('recommend desc').limit(20).size - 1
      (0..rcmd_videos_size).to_a.sample(10).each_with_object([]) do |i, videos|
        videos << NewArrival.order('recommend desc')[i]
      end
    end

    #### shortcut commands ####

    # FC2に存在しない動画を削除
    def check_available
      Video.find_each do |video|
        video.destroy unless video.available_on_fc2?
      end
    end

    # 全部消して初期化する 750000を検索
    def set_init
      Video.destroy_all
      Fc2.scrape('adult', 1, 17_000)
      Fc2.scrape('normal', 1, 17_000)
    end
  end
end
