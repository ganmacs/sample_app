require 'spec_helper'

describe "UserPages" do

  describe 'profile page' do
    let(:user) { FactoryGirl.create(:user)}
    before { visit user_path(user) }


    it { expect(page).to have_content(user.name) }
    it { expect(page).to have_title(user.name) }
  end

  describe "signup page" do
    before { visit signup_path }
    let(:submit) { "Create my account" }

    describe 'with invalid information'do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end

    it { expect(page).to have_content('Sign Up')}
    it { expect(page).to have_title(full_title('Sign Up'))}
  end
end
