require 'rails_helper'

RSpec.feature 'ユーザー登録', type: :feature do
  scenario 'ユーザーを登録する' do
    visit new_user_registration_path

    within('#username-form') do
      fill_in 'user[username]', with: 'guest'
    end
    within('#email-form') do
      fill_in 'user[email]', with: 'guest@example.com'
    end
    within('#password-form') do
      fill_in 'user[password]', with: 'guestpassword'
    end
    within('#password_confirmation-form') do
      fill_in 'user[password_confirmation]', with: 'guestpassword'
    end

    within('#loginbtn-form') do
      click_button '新規登録'
    end

    expect(page).to have_content '本人確認用のメールを送信しました。'
  end
end
