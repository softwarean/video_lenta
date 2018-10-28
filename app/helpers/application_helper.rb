module ApplicationHelper
  def player_uri(folder)
    PlayerUriFormatter.index_file_uri(folder)
  end

  def player_folder_uri(folder)
    PlayerUriFormatter.folder_uri(folder)
  end

  def meta_description
    @description || t("meta.description")
  end

  def meta_title
    @meta_title || t("meta.title")
  end

  def title
    @title || t("title")
  end
end
