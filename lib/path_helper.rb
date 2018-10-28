module PathHelper
  class << self
    def report_path
      time = Time.now.in_time_zone("Moscow").strftime("%y%m%d-%H%M%S")
      "#{Rails.root}/tmp/domdfo-#{time}.csv"
    end
  end
end
