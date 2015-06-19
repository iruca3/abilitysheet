class UserDecorator < Draper::Decorator
  delegate_all

  def pref
    "#{Grade::PREF[object.pref]}"
  end

  def grade
    "#{Grade::GRADE[object.grade]}"
  end

  def current
    "#{object.current_sign_in_at.strftime('%Y/%m/%d %H:%M')}/#{object.current_sign_in_ip}"
  end

  def last
    "#{object.last_sign_in_at.strftime('%Y/%m/%d %H:%M')}/#{object.last_sign_in_ip}"
  end
end