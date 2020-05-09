# frozen_string_literal: true

module ApplicationHelper
  # WebsiteName
  WEBSITE_NAME = 'ゴルコミュ'
  # ModalMode
  EASY_LOGIN_MODAL_MODE = '1'
  DELETE_USER_MODAL_MODE = '2'
  PARTICIPATE_EVENT_MODAL_MODE = '3'
  STOP_PARTICIPATE_EVENT_MODAL_MODE = '4'
  DELETE_ACCOUNT_MODAL_MODE = '5'
  DELETE_EVENT_MODAL_MODE = '6'
  # EventCardMode
  NORMAL_EVENT_CARD_MODE = '1'
  PARTICIPATED_EVENT_CARD_MODE = '2'
  LIKED_EVENT_CARD_MODE = '3'

  def full_title(page_title = '')
    base_title = WEBSITE_NAME
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def current_user?(user)
    user == current_user
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
