class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Checks the parameter.
  # Nil and empty string are allowed, and return nil.
  #
  def int_param(param_name)
    param_value = params[param_name]

    case param_value
    when /\A\d+\Z/
      param_value.to_i
    when nil, ""
      nil
    else
      raise "Invalid '#{param_name}' parameter value!"
    end
  end

  def boolean_param(param_name)
    param_value = params[param_name]

    case param_value
    when "true"
      true
    when "false"
      false
    when nil, ""
      nil
    else
      raise "Invalid '#{param_name}' parameter value!"
    end
  end

  # Checks the parameter from a whitelist.
  # Nil and empty string are allowed, and return nil.
  #
  def whitelist_param(param_name, whitelist)
    param_value = params[param_name]

    if param_value.to_s == ""
      nil
    elsif whitelist.include?(param_value)
      param_value
    else
      raise "Invalid '#{param_name}' parameter value!"
    end
  end
end
