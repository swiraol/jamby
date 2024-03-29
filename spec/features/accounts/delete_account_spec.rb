require 'rails_helper'

feature 'Users can delete their accounts' do
  scenario 'User deletes their account' do
    page = AccountDashboardPage.new
    user = create(:signup)

    logged_in(user) do
      visit root_path
      click_link user.first_name
      click_link page.delete_account_link_text
    end

    expect(current_path).to eq(page.after_successful_delete_path)
    expect(page).to have_css('.alert-box.info',
                             text: page.successful_delete_text)
    expect(page).to have_link('Guest')

    page = SignInPage.new
    page.visit

    page.fill_in_form('Email' => user.email, 'Password' => user.password)
    page.submit_form

    expect(current_path).to eq(page.after_failed_signin_path)
    expect(page).to have_css('.alert-box.alert',
                             text: page.invalid_credentials_text)
  end
end
