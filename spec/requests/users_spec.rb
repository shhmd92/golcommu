require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let!(:user) { create(:user) }
  let!(:admin_user) { create(:user, :admin) }

  describe 'GET #index' do
    example 'リクエストが成功すること' do
      sign_in(user)
      get users_path
      expect(response).to have_http_status 200
    end
  end

  describe 'GET #search' do
    before do
      @search_item_hash = { prefecture: 1, ages: 1, age_min: 1, age_max: 19,
                            sex: 1, play_type: 1 }
    end

    example 'リクエストが成功すること' do
      get search_users_path(@search_item_hash)
      expect(response).to have_http_status 200
    end

    example 'ユーザー一覧にレンダーすること' do
      get search_users_path(@search_item_hash)
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    context 'ユーザーが存在する場合' do
      example 'リクエストが成功すること' do
        get user_path(user)
        expect(response).to have_http_status 200
      end
    end

    context 'ユーザーが存在しない場合' do
      subject { -> { get user_path(1) } }
      it { is_expected.to raise_error ActiveRecord::RecordNotFound }
    end
  end

  describe 'GET #following' do
    example 'リクエストが成功すること' do
      get following_user_path(user)
      expect(response).to have_http_status 200
    end

    example 'フォローリストにレンダーすること' do
      get following_user_path(user)
      expect(response).to render_template :following
    end
  end

  describe 'GET #followers' do
    example 'リクエストが成功すること' do
      get followers_user_path(user)
      expect(response).to have_http_status 200
    end

    example 'フォローリストにレンダーすること' do
      get followers_user_path(user)
      expect(response).to render_template :followers
    end
  end

  describe 'DELETE #destroy' do
    context '管理者ユーザの場合' do
      example 'リクエストが成功すること' do
        sign_in(admin_user)
        delete user_path(user)
        expect(response.status).to eq 302
      end

      example 'ユーザーが削除されること' do
        sign_in(admin_user)
        expect do
          delete user_path(user)
        end.to change(User, :count).by(-1)
      end

      example 'ユーザー一覧にリダイレクトすること' do
        sign_in(admin_user)
        delete user_path(user)
        expect(response).to redirect_to(users_path)
      end
    end

    context '一般ユーザーの場合' do
      example 'リクエストが成功すること' do
        sign_in(user)
        delete user_registration_path
        expect(response.status).to eq 302
      end

      example 'アカウントが削除されること' do
        sign_in(user)
        expect do
          delete user_registration_path
        end.to change(User, :count).by(-1)
      end

      example 'トップページにリダイレクトすること' do
        sign_in(user)
        delete user_registration_path
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
