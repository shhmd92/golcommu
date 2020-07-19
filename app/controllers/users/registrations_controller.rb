# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  protected

  def update_resource(resource, params)
    resource.update_without_current_password(params)
  end

  def after_update_path_for(resource)
    edit_user_registration_path(resource)
  end

  def after_inactive_sign_up_path_for(_resource)
    send_mail_path
  end
end
