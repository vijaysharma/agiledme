class Epic < Story
  has_many :stories, :class_name => 'Story', :foreign_key => "epic_id"

  def is_estimatable?
    false
  end

end
