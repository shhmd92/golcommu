require 'rails_helper'

RSpec.describe 'EditUsers', type: :system do
  let!(:user) { create(:user) }

  context 'ユーザー編集成功' do
    example 'ユーザーの編集ができること' do
      sign_in(user)

      visit edit_user_registration_path

      fill_in 'user[username]', with: 'username'
      attach_file 'user[avatar]', "#{Rails.root}/spec/fixtures/test.png", make_visible: true
      choose '未設定'
      select '2000', from: 'user[birth_date(1i)]'
      select '1', from: 'user[birth_date(2i)]'
      select '10', from: 'user[birth_date(3i)]'
      select '東京都', from: 'user[prefecture]'
      select 'シングル（70台）', from: 'user[average_score]'
      select 'エンジョイ系', from: 'user[play_type]'
      fill_in 'user[introduction]', with: 'introduction'
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'

      click_button '更新'
      expect(page).to have_content 'アカウント情報を変更しました'
    end
  end

  context 'ユーザー編集失敗' do
    example 'ユーザーの編集ができないこと' do
      sign_in(user)

      visit edit_user_registration_path

      fill_in 'user[username]', with: ''
      attach_file 'user[avatar]', "#{Rails.root}/spec/fixtures/test.png", make_visible: true

      click_button '更新'
      expect(page).not_to have_content 'アカウント情報を変更しました'
    end
  end
end
