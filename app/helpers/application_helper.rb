# frozen_string_literal: true

module ApplicationHelper
  def website_name
    'GolfMenta'
  end

  # ページごとの完全なタイトルを返します
  def full_title(page_title = '')
    base_title = website_name
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
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
