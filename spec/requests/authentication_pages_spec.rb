require 'spec_helper'

describe "AuthenticationPages" do

  let(:sign_in) { 'Sign in' }
  let(:sign_out) { 'Sign out' }

  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  describe 'signin page' do
    before { visit signin_path }
    it { expect(page).to have_content(sign_in)}
    it { expect(page).to have_title(sign_in)}
  end

  describe 'signin' do
    before { visit signin_path }

    describe 'with invalid information' do
      before { click_button sign_in }

      it { expect(page).to have_title(sign_in)}
      it { expect(page).to have_error_message('Invalid') }

      describe 'after visiting another page' do
        before { click_link 'Home' }
        it { expect(page).not_to have_error_message('Invalid') }
      end
    end

    describe 'with valid information' do
      let(:user) { FactoryGirl.create(:user)}
      before { valid_signin(user) }

      it { expect(page).to have_title(user.name) }
      it { expect(page).to have_link(sign_out, href: signout_path) }
      it { expect(page).to have_link('Profile', href: user_path(user)) }
      it { expect(page).not_to have_link( sign_in, href: signin_path) }

      describe 'followed by signout' do
        before { click_link sign_out}
        it { expect(page).to have_link(sign_in)}
      end
    end
  end

  describe 'remember token' do
    before { @user.save }
    it { expect(@user.remember_token).not_to be_blank }
  end
end
