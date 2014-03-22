require 'spec_helper'

describe "AuthenticationPages" do

  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  describe 'signin page' do
    before { visit signin_path }

    it { expect(page).to have_content('Sign in')}
    it { expect(page).to have_title('Sign in')}
  end

  describe 'signin' do
    before { visit signin_path }

    describe 'with invalid information' do
      before { click_button 'Sign in' }

      it { expect(page).to have_title('Sign in')}
      it { expect(page).to have_selector('div.alert.alert-error', text: 'Invalid')}

      describe 'after visiting another page' do
        before { click_link 'Home' }
        it { expect(page).not_to have_selector('div.alert.alert-error')}
      end
    end

    describe 'with valid information' do
      let(:user) { FactoryGirl.create(:user)}
      before do
        fill_in "Email", with: user.email.upcase
        fill_in "Password", with: user.password
        click_button 'Sign in'
      end

      it { expect(page).to have_title(user.name) }
      it { expect(page).to have_link('Sign out', href: signout_path) }
      it { expect(page).to have_link('Profile', href: user_path(user)) }
      it { expect(page).not_to have_link('Sign in', href: signin_path) }

      describe 'followed by signout' do
        before { click_link 'Sign out'}
        it { expect(page).to have_link('Sign in')}
      end

    end

  end

  describe 'remember token' do
    before { @user.save }
    it { expect(@user.remember_token).not_to be_blank }
  end

end
