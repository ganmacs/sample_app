require 'spec_helper'

describe "UserPages" do

  describe 'index page' do
    let(:user) { FactoryGirl.create(:user) }
    before do
      valid_sign_in user
      visit users_path
    end

    it { expect(page).to have_title('All Users')}
    it { expect(page).to have_content('All Users')}

    describe 'pagination' do
      before(:all) { 30.times { FactoryGirl.create(:user)} }
      after(:all) { User.delete_all }

      it { expect(page).to have_selector('div.pagination')}

      it 'should list each users' do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end

    end

    describe 'delete link' do
      it { expect(page).not_to have_link('Delete')}

      describe 'as an admin user' do
        let(:admin) { FactoryGirl.create(:admin)}
        before do
          valid_sign_in admin
          visit users_path
        end

        it { expect(page).to have_link('delete', href: user_path(User.first))}
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        it { expect(page).not_to have_link('delete', href: user_path(admin))}
      end
    end

  end

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

      describe 'after submittion' do
        before { click_button submit }
        it { expect(page).to have_title('Sign Up')}
        it { expect(page).to have_content('error')}
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

      describe 'after saving the user' do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com')}

        it { expect(page).to have_link('Sign out') }
        it { expect(page).to have_title(user.name) }
        it { expect(page).to have_selector('div.alert.alert-success', text: 'Welcome')}
      end

    end

    it { expect(page).to have_content('Sign Up')}
    it { expect(page).to have_title(full_title('Sign Up'))}
  end

  describe 'edit' do
    let(:user) { FactoryGirl.create(:user) }
    before do
      valid_sign_in user
      visit edit_user_path(user)
    end

    describe 'forbidden attributes' do
      let(:params) do
        {user: {admin: true, password: user.password, password_confirmation: user.password}}
      end
      before do
        valid_sign_in user , no_capybara: true
        patch user_path(user), params
      end

      it { expect(user.reload).not_to be_admin}
    end

    describe 'page' do
      it { expect(page).to have_content('Update your profile') }
      it { expect(page).to have_title('Edit user') }
      it { expect(page).to have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe 'with invalid information' do
      before { click_button 'Save changes'}
      it { expect(page).to have_content('error') }
    end

    describe 'with valid information' do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in 'Name',  with: new_name
        fill_in 'Email', with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm", with: user.password
        click_button "Save changes"
      end

      it { expect(page).to have_title(new_name) }
      it { expect(page).to have_selector('div.alert.alert-success') }
      it { expect(page).to have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to  eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end
  end


end
