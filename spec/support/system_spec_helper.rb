module SystemSpecHelper
  def sign_in(user)
    visit new_user_session_path

    within('#email-form') do
      fill_in 'user[email]', with: user.email
    end
    within('#password-form') do
      fill_in 'user[password]', with: user.password
    end

    within('#loginbtn-form') do
      click_button 'ログイン'
    end

    expect(page).to have_content 'ログインしました。'
  end

  def sign_out
    click_link 'ログアウト'
    expect(page).to have_content 'ログアウトしました。'
  end
end
