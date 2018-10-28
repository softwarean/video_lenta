class ChangeCoordsToFloat < ActiveRecord::Migration
  def up
    execute 'ALTER TABLE buildings ALTER COLUMN latitude TYPE double precision USING CAST(latitude AS double precision)'
    execute 'ALTER TABLE buildings ALTER COLUMN longitude TYPE double precision USING CAST(longitude AS double precision)'
  end

  def down
    execute 'ALTER TABLE buildings ALTER COLUMN latitude TYPE varchar(255) USING CAST(latitude AS varchar)'
    execute 'ALTER TABLE buildings ALTER COLUMN longitude TYPE varchar(255) USING CAST(longitude AS varchar)'
  end
end
