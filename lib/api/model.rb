module Api::Model

  def set_user
    self.app_user = $current_user
  end

end