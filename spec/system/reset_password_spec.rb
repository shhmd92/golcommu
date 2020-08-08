require 'rails_helper'

RSpec.describe 'ResetPassword', type: :system do
  # テストの際は非同期をやめる
  Devise::Async.enabled = false

  before do
    ActionMailer::Base.deliveries.clear
  end

  def extract_confirmation_url(mail)
    body = mail.body.encoded
    body[/http[^"]+/]
  end

  context '変更成功' do
    example 'パスワード変更できること' do
      user = create(:user)

      visit new_user_session_path

      click_link 'パスワードをお忘れですか?'
      expect(current_path).to eq new_user_password_path

      within('#email-form') do
        fill_in 'user[email]', with: user.email
      end

      expect do
        click_button '送信する'
      end.to change { ActionMailer::Base.deliveries.size }.by(1)

      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'パスワードの再設定についてメールをお送りしました。'

      mail = ActionMailer::Base.deliveries.last
      reset_password_url = extract_confirmation_url(mail)

      aggregate_failures do
        expect(mail.to).to eq [user.email]
        expect(mail.from).to eq ['info@golcommu.com']
        expect(mail.subject).to eq 'パスワードの再設定について'
        expect(mail.body).to have_link 'パスワードを変更する', href: reset_password_url
      end

      visit reset_password_url
      expect(page).to have_content 'パスワード変更'

      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
      click_button '変更'

      expect(page).to have_content 'パスワードが正しく変更されました'

      expect(user.reload.valid_password?('password')).to eq true
    end
  end
end
