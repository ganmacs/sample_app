require 'spec_helper'

describe "Authentication" do

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
      before { valid_sign_in user }

      it { expect(page).to have_title(user.name) }
      it { expect(page).to have_link(sign_out, href: signout_path) }
      it { expect(page).to have_link('Users', href: users_path) }
      it { expect(page).to have_link('Profile', href: user_path(user)) }
      it { expect(page).to have_link('Setting', href: edit_user_path(user)) }
      it { expect(page).not_to have_link(sign_in, href: signin_path) }

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

  describe "authorization" do

    describe 'as non-admin user' do
      let(:user)   { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { valid_sign_in non_admin, no_capybara: true }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end

    describe 'for non-signed-in users' do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Users controller" do
        describe "visiting the user index" do
          before { visit users_path }
          it { expect(page).to have_title('Sign in') }
        end

        describe 'visiting the edit page' do
          before { visit edit_user_path(user) }
          it { expect(page).to have_title(sign_in) }
        end

        describe 'submitting to the update action' do
          before { patch user_path(user)}
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe 'visiting the following page' do
          before { visit following_user_path(user)}
          it { expect(page).to have_title('Sign in')}
        end

        describe 'visiting the followers page' do
          before { visit followers_user_path(user)}
          it { expect(page).to have_title('Sign in')}
        end
      end

      describe 'when attempting to visit a protected page' do
        before do
          visit edit_user_path(user)
          fill_in 'Email', with: user.email
          fill_in 'Password', with: user.password
          click_button 'Sign in'
        end

        describe 'after signing in' do
          it 'should render the desired protected page' do
            expect(page).to have_title('Edit user')
          end

          describe 'when signing in agein' do
            before do
              delete signout_path
              visit signin_path
              fill_in 'Email', with: user.email
              fill_in 'Password', with: user.password
              click_button  'Sign in'
            end

            it 'should render the profile page' do
              expect(page).to have_title(user.name)
            end
          end
        end
      end

      describe 'in the Microposts controller' do

        describe 'submitting to the  create action' do
          before { post microposts_path }
          specify {expect(response).to redirect_to(signin_path)}
        end

        describe 'submitting to the  destroy action' do
          before { delete micropost_path(FactoryGirl.create(:micropost)) }
          specify { expect(response).to redirect_to(signin_path)}
        end
      end

      describe 'in the Relationships controller' do
        describe 'submitting to the create action' do
          before { post relationships_path }
          it { expect(response).to redirect_to(signin_path) }
        end

        describe 'submitting to the destroy action' do
          before { delete relationship_path(1) }
          it { expect(response).to redirect_to(signin_path)}
        end
      end
    end

    describe 'as wrong user' do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { valid_sign_in user, no_capybara: true}
    end
  end
end
