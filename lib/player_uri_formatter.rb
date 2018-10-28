module PlayerUriFormatter
  class << self
    def folder_uri(folder)
      "#{configus.player.path}#{folder}/"
    end

    def index_file_uri(folder)
      "#{folder_uri(folder)}#{configus.player.index_file}"
    end
  end
end
