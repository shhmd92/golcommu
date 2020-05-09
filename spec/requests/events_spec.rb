require 'rails_helper'

RSpec.describe 'Events', type: :request do
  let!(:user) { create(:user) }
  let!(:event) { create(:event, user: user) }
  let!(:uncreate_event) { build(:event, user: user) }

  describe 'GET #index' do
    example 'リクエストが成功すること' do
      sign_in(user)
      get events_path
      expect(response).to have_http_status 200
    end
  end

  describe 'GET #new' do
    example 'リクエストが成功すること' do
      sign_in(user)
      get new_event_path
      expect(response).to have_http_status 200
    end
  end

  describe 'GET #show' do
    context 'イベントが存在する場合' do
      example 'リクエストが成功すること' do
        sign_in(user)
        get event_path(event)
        expect(response).to have_http_status 200
      end
    end

    context 'イベントが存在しない場合' do
      subject { -> { get event_path(uncreate_event) } }
      it { is_expected.to raise_error ActiveRecord::RecordNotFound }
    end
  end

  describe 'POST #create' do
    context 'パラメータが妥当な場合' do
      example 'リクエストが成功すること' do
        sign_in(user)
        post events_path, params: { event: attributes_for(:event, user: user) }
        expect(response.status).to eq 302
      end

      example 'イベントが登録されること' do
        expect do
          sign_in(user)
          post events_path, params: { event: attributes_for(:event, user: user) }
        end.to change(Event, :count).by(1)
      end
    end

    context 'パラメータが不正な場合' do
      example 'リクエストが成功すること' do
        sign_in(user)
        post events_path, params: { event: attributes_for(:event, :invalid, user: user) }
        expect(response.status).to eq 200
      end

      example 'イベントが登録されないこと' do
        expect do
          sign_in(user)
          post events_path, params: { event: attributes_for(:event, :invalid, user: user) }
        end.to_not change(Event, :count)
      end

      example 'エラーが表示されること' do
        sign_in(user)
        post events_path, params: { event: attributes_for(:event, :invalid, user: user) }
        expect(assigns(:event).errors.any?).to be_truthy
      end
    end
  end

  describe 'DELETE #destroy' do
    example 'リクエストが成功すること' do
      sign_in(user)
      delete event_path(event)
      expect(response.status).to eq 302
    end

    example 'イベントが削除されること' do
      sign_in(user)
      expect do
        delete event_path(event)
      end.to change(Event, :count).by(-1)
    end

    example 'トップページにリダイレクトすること' do
      sign_in(user)
      delete event_path(event)
      expect(response).to redirect_to(root_path)
    end

    # TODO: ユーザー詳細画面からイベントを削除したときのテストも必要
  end

  describe 'GET #edit' do
    example 'リクエストが成功すること' do
      get edit_event_path(event)
      expect(response.status).to eq 200
    end
  end

  describe 'PUT #update' do
    context 'パラメータが妥当な場合' do
      example 'リクエストが成功すること' do
        sign_in(user)
        put event_path(event), params: { event: attributes_for(:event, :update_title, user: user) }
        expect(response.status).to eq 302
      end

      example 'イベントが登録されること' do
        expect do
          sign_in(user)
          put event_path(event), params: { event: attributes_for(:event, :update_title, user: user) }
        end.to change { Event.find(event.id).title }.from(event.title).to('update title')
      end
    end

    context 'パラメータが不正な場合' do
      example 'リクエストが成功すること' do
        sign_in(user)
        put event_path(event), params: { event: attributes_for(:event, :invalid, user: user) }
        expect(response.status).to eq 200
      end

      example 'イベントが登録されないこと' do
        expect do
          sign_in(user)
          put event_path(event), params: { event: attributes_for(:event, :invalid, user: user) }
        end.to_not change(Event, :count)
      end

      example 'エラーが表示されること' do
        sign_in(user)
        put event_path(event), params: { event: attributes_for(:event, :invalid, user: user) }
        expect(assigns(:event).errors.any?).to be_truthy
      end
    end
  end

  describe 'GET #search' do
    example 'リクエストが成功すること' do
      sign_in(user)
      get search_events_path
      expect(response).to have_http_status 200
    end
  end
end
