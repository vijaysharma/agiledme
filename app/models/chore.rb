class Chore < Story
  def is_estimatable?
    self.project.estimate_chores?;
  end
end
