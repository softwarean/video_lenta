class Picture < ActiveRecord::Base
  belongs_to :building
  mount_uploader :file, PictureUploader
end
