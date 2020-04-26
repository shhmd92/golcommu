include Warden::Test::Helpers

module RequestSpecHelper
  def sign_in(user)
    login_as user, scope: :user
  end
end
