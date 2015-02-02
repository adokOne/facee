class ApplicationController < ActionController::Base
  I18n.locale = :ru
  protect_from_forgery
end
