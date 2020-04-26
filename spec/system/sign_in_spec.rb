require 'rails_helper'

RSpec.describe 'ログインとログアウト', type: :system do
  let!(:user) { create(:user, :guest) }

  context 'ログイン成功' do
    example '通常ログインができること' do
      sign_in(user)

      sign_out
    end

    example 'お試しログインができること' do
      visit root_path

      within('#modal-btn') do
        click_button 'ログイン'
      end
      expect(page).to have_content 'ログインしました'

      sign_out
    end
  end

  context 'ログイン失敗' do
    example 'ログインできないこと' do
      visit new_user_session_path

      within('#email-form') do
        fill_in 'user[email]', with: 'not-login@example.com'
      end
      within('#password-form') do
        fill_in 'user[password]', with: 'password'
      end

      within('#loginbtn-form') do
        click_button 'ログイン'
      end
      expect(page).not_to have_content 'ログインしました'
    end
  end
end
