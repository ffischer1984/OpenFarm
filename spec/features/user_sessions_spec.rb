require 'spec_helper'

describe 'User sessions' do
  include IntegrationHelper
  let(:user) { FactoryGirl.create(:user) }

  it 'registers for an account' do
    visit root_path
    click_link 'register'
    fill_in :user_display_name, with: 'Rick'
    fill_in :user_password, with: 'password123'
    fill_in :user_email, with: 'm@il.com'
    click_button 'Create User'
    see 'Welcome! You have signed up successfully.'
    usr = User.find_by(email: 'm@il.com')
    expect(usr.display_name).to eq('Rick')
    expect(usr.valid_password?('password123')).to eq(true)
    expect(usr.email).to eq('m@il.com')
  end

  it 'logs out' do
    login_as user
    visit root_path
    click_link 'Log out'
    see('Signed out successfully.')
  end

  it 'does not let the user access the admin panel' do
    visit rails_admin.dashboard_path
    expect(page).to have_content('I told you kids to get out of here!')
  end

  it 'should redirect the user to their edit page after sign up' do
    visit new_user_registration_path
    fill_in :user_display_name, with: 'Rick'
    fill_in :user_password, with: 'password123'
    fill_in :user_email, with: 'm@il.com'
    click_button 'Create User'
    expect(page).to have_content("Need to make some changes?")
  end

  it 'should redirect the user to the page they were viewing after sign up' do
    visit "/guides/new"
    see ("You need to sign in or sign up before continuing.")
    click_link "Sign up"
    fill_in :user_display_name, with: 'Rick'
    fill_in :user_password, with: 'password123'
    fill_in :user_email, with: 'm@il.com'
    click_button 'Create User'
    expect(page).to have_content("Create a Guide")
  end
end
