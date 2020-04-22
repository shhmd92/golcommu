require 'rails_helper'

RSpec.feature 'ログインとログアウト', type: :feature do
  background do
    create(:user, :guest)
  end

  scenario '通常ログインをする' do
    # login
    visit new_user_session_path

    within('#email-form') do
      fill_in 'user[email]', with: 'guest@example.com'
    end
    within('#password-form') do
      fill_in 'user[password]', with: 'guestpassword'
    end

    within('#loginbtn-form') do
      click_button 'ログイン'
    end
    expect(page).to have_content 'ログインしました'

    # logout
    click_link 'ログアウト'
    expect(page).to have_content 'ログアウトしました'
  end

  scenario 'お試しログインをする' do
    # login
    visit root_path

    within('#modal-btn') do
      click_button 'ログイン'
    end
    expect(page).to have_content 'ログインしました'

    # logout
    click_link 'ログアウト'
    expect(page).to have_content 'ログアウトしました'
  end
end
