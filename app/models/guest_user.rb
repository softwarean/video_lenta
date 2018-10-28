class GuestUser
  def guest?
    true
  end

  def method_missing(method_name, *args)
    nil
  end
end
