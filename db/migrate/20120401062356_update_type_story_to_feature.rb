class UpdateTypeStoryToFeature < ActiveRecord::Migration
  def up
    execute "UPDATE stories SET type = 'Feature' where type = 'Story'"
  end

  def down
    execute "UPDATE stories SET type = 'Story' where type = 'Feature'"
  end
end
