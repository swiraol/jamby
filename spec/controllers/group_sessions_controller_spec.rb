require 'rails_helper'

describe GroupSessionsController do
  describe 'GET #cancel_booking' do
    it 'cancels the booking and redirects with the flash notice' do
      user = create(:user)
      group_session = create(:group_session)

      allow(controller).to receive(:current_user).and_return(user)
      Booking.create(group_session, user)

      get :cancel_booking, id: group_session.to_param

      expect(Booking.count).to eq(0)
      expect(response).to redirect_to(group_session_path(group_session))
      expect(flash[:info]).to eq(
        I18n.t('controllers.group_sessions.cancel_booking.successful')
      )
    end

    it 'cancels paid bookings' do
      user = create(:account)
      group_session = create(:priced_group_session)

      allow(controller).to receive(:current_user).and_return(user)
      allow(controller).to receive(:current_account).and_return(user)
      Booking.create(group_session, user)
      Payment.create!(group_session: group_session, account: user)

      get :cancel_booking, id: group_session.to_param

      expect(Payment.last.deleted_at).to_not be_nil
    end
  end

  describe 'before filter' do
    it 'stores location for index' do
      get :index
      expect(session[:previous_url]).to eq(group_sessions_path)
    end

    it 'stores location for new' do
      get :new
      expect(session[:previous_url]).to eq(new_group_session_path)
    end

    it 'stores location for show' do
      group_session = create(:group_session)
      get :show, id: group_session.to_param
      expect(session[:previous_url]).to eq(group_session_path(group_session.to_param))
    end

    it 'stores location for edit' do
      get :edit, id: 1
      expect(session[:previous_url]).to eq(edit_group_session_path(1))
    end

    it 'stores location for book' do
      get :book, id: 1
      expect(session[:previous_url]).to eq(book_group_session_path(1))
    end

    it 'authorizes edits' do
      owner = create(:user)
      intruder = create(:user)
      group_session = create(:group_session, host: owner)

      allow(controller).to receive(:current_user).and_return(owner)
      get :edit, id: group_session.to_param
      expect(response).to be_successful

      allow(controller).to receive(:current_user).and_return(intruder)
      get :edit, id: group_session.to_param
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq(I18n.t('controllers.application.unauthorized'))
    end

    it 'authorizes destroys' do
      owner = create(:user)
      intruder = create(:user)
      group_session = create(:group_session, host: owner)

      allow(controller).to receive(:current_user).and_return(owner)
      delete :destroy, id: group_session.to_param
      expect(response).to redirect_to(root_path)
      expect(flash[:info]).to eq(I18n.t('controllers.group_sessions.destroy.successful'))

      group_session = create(:group_session, host: owner)
      allow(controller).to receive(:current_user).and_return(intruder)
      delete :destroy, id: group_session.to_param
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq(I18n.t('controllers.application.unauthorized'))
    end
  end

  describe '#GET book' do
    it 'redirects to confirm payment for priced sessions' do
      user = create(:user)
      group_session = create(:priced_group_session)

      allow(controller).to receive(:current_user).and_return(user)
      get :book, id: group_session.to_param

      expect(response).to redirect_to(confirm_payment_path(group_session))
    end

    it 'redirects the user back to their referer' do
      user = create(:user)
      allow(controller).to receive(:current_user).and_return(user)
      request.env['HTTP_REFERER'] = '/foo/bar'
      group_session = create(:group_session)

      get :book, id: group_session.to_param
      expect(response).to redirect_to('/foo/bar')
    end

    it 'does not redirect back to signin/signup pages' do
      group_session = create(:group_session)
      user = create(:user)

      allow(controller).to receive(:current_user).and_return(user)

      request.env['HTTP_REFERER'] = signin_path
      get :book, id: group_session.to_param
      expect(response).to redirect_to(group_session_path(group_session))

      request.env['HTTP_REFERER'] = signup_path
      get :book, id: group_session.to_param
      expect(response).to redirect_to(group_session_path(group_session))
    end
  end
end
