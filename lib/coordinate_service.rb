class CoordinateService
  class << self
    COORD_REGEX = /(?:(?<degrees>\d+)[°º])(?:\s*(?<minutes>\d+(?:\.\d)?)['`’])(?:\s*(?<seconds>\d+)(?:["]|['`’]{2}))?/

    def to_dd(value)
      if coords = value.to_s.match(COORD_REGEX)
        value = coords[:degrees].to_f + coords[:minutes].to_f/60 + coords[:seconds].to_f/3600
      end

      value
    end

    def coord?(value)
      is_float?(value) || value.to_s.match(COORD_REGEX)
    end

    private
    def is_float?(fl)
      !!Float(fl) rescue false
    end

  end
end
