class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Checks the parameter.
  # Nil is allowed; an empty string is considered nil.
  #
  def int_param( param_name )
    case params[ param_name ]
    when /\A\d+\Z/
      params[ param_name ].to_i
    when nil, ""
      nil
    else
      raise "Invalid #{ param_name } parameter!"
    end
  end

end
