class Document < ActiveRecord::Base
  belongs_to :building
  mount_uploader :file, DocumentUploader
end
