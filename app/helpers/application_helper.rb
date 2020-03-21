# frozen_string_literal: true

module ApplicationHelper
   # Webサイト名
  WEBSITE_NAME = 'GolfMenta'
  # モーダルモード
  EASY_LOGIN_MODAL_MODE = '1'
  DELETE_USER_MODAL_MODE = '2'
  PARTICIPATE_EVENT_MODAL_MODE = '3'
  STOP_PARTICIPATE_EVENT_MODAL_MODE = '4'

  # ページごとの完全なタイトルを返します
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
