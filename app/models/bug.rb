class Bug < Story
  def is_estimatable?
    self.project.estimate_bugs?
  end
end
