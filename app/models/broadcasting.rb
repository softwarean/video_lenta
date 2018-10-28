class Broadcasting < ActiveRecord::Base
  extend Enumerize

  belongs_to :building
  validates :slug, uniqueness: true, allow_blank: true
  validates :slug, format: { without: /\s/ }
  validates :url, format: URI::regexp(%w(http https rtsp)), allow_blank: true

  state_machine :state, initial: :active do
    event(:activate) { transition any => :active }
    event(:deactivate) { transition any => :inactive }
  end

  def status
    if last_frame_time.nil?
      return :inactive
    end

    if finish_datetime && finish_datetime < DateTime.now
      return :finished
    end

    last_time = last_frame_time
    last_time -= building.district.region.timezone_offset * 1.minute if camera_type.ftp?

    if last_time > configus.broadcasting.active_time.ago
      :active
    else
      :outdated
    end
  end

  include BroadcastingRepository

  enumerize :camera_type, in: [:http, :ftp], scope: true
end
