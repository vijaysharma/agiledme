class Bug < WorkableItem
  def is_estimatable?
    self.project.estimate_bugs?
  end
end
