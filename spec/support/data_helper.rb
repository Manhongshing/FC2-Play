module DataHelper
  def create_base_data
    create(:user)
    create_new_arrivals
    create_ranks
  end

  private

  def create_new_arrivals
    2.times do |i|
      next_id = last_video_id + 1
      create(:video, id: i + next_id)
      create(:new_arrival, video_id: i + next_id)
    end
  end

  def create_ranks
    5.times do |i|
      next_id = last_video_id + 1
      create(:video, id: i + next_id)
      create(:weekly_rank, video_id: i + next_id)
      create(:video, id: i + next_id + 50)
      create(:monthly_rank, video_id: i + next_id + 50)
    end
  end

  def last_video_id
    Video.last.present? ? Video.last.id : 0
  end
end
