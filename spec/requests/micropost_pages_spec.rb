require 'spec_helper'

describe "MicropostPages" do
  let(:user) { FactoryGirl.create(:user) }
  before { valid_sign_in user }

  describe 'micropost createion' do
    before { visit root_path }

    describe 'with invalid information' do

      it 'should not create a micropost' do
        expect { click_button 'Post' }.not_to change(Micropost, :count)
      end

      describe 'error messages' do
        before { click_button 'Post'}
        it {expect(page).to have_content('error')}
      end
    end

    descrie 'with valid information' do
      before { fill_in 'micropost_content', with: 'Lorem ipsum'}
      it 'should cerate a micropost' do
        expect { click_button 'Post' }.to change(Micropost, :count).by(1)
      end
    end
  end

  describe 'should delete a micropost' do
    before { FactoryGirl.create(:micropost, user: user) }

    describe 'as correct user' do
      before { visit root_path }

      it 'should delete a micropost' do
        expect { click_link 'delete' }.to change(Micropost, :count).by(-1)
      end
    end
  end

end
