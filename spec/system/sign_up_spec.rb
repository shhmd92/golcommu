require 'rails_helper'

RSpec.describe 'ユーザー登録', type: :system do
  # テストの際は非同期をやめる
  Devise::Async.enabled = false

  before do
    ActionMailer::Base.deliveries.clear
  end

  def extract_confirmation_url(mail)
    body = mail.body.encoded
    body[/http[^"]+/]
  end

  context '登録成功' do
    example 'ユーザー登録できること' do
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

      mail = ActionMailer::Base.deliveries.last
      confirmation_url = extract_confirmation_url(mail)
      visit confirmation_url
      expect(current_path).to eq complete_registration_path
    end
  end

  context '登録失敗' do
    example 'ユーザー登録できないこと' do
      visit new_user_registration_path

      within('#username-form') do
        fill_in 'user[username]', with: ''
      end
      within('#email-form') do
        fill_in 'user[email]', with: ''
      end
      within('#password-form') do
        fill_in 'user[password]', with: ''
      end
      within('#password_confirmation-form') do
        fill_in 'user[password_confirmation]', with: ''
      end

      within('#loginbtn-form') do
        click_button '新規登録'
      end

      aggregate_failures do
        expect(page).to have_content 'ユーザーネームを入力してください'
        expect(page).to have_content 'Eメールを入力してください'
        expect(page).to have_content 'パスワードを入力してください'
      end

      within('#password-form') do
        fill_in 'user[password]', with: 'password'
      end
      within('#password_confirmation-form') do
        fill_in 'user[password_confirmation]', with: ''
      end

      within('#loginbtn-form') do
        click_button '新規登録'
      end

      expect(page).to have_content 'パスワードの入力が一致しません'
    end
  end
end
