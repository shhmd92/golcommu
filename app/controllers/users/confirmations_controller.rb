# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  protected

  def after_confirmation_path_for(_resource_name, _resource)
    complete_registration_path
  end
end
