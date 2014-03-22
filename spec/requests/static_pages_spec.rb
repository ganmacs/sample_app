require 'spec_helper'

describe "StaticPages" do

  shared_examples_for "all static pages" do
    it { expect(page).to have_content(heading) }
    it { expect(page).to have_title(full_title(page_title)) }
  end

  describe "Home Page" do
    before { visit root_path }
    let(:heading)    { 'Sample App' }
    let(:page_title) { '' }

    it_behaves_like "all static pages"
    it { expect(page).not_to have_title("| Home") }
  end

  describe "Help Page" do
    before { visit help_path }

    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }

    it_behaves_like "all static pages"
  end

  describe "About Page" do
    before { visit about_path }
    let(:heading)    { 'About Us' }
    let(:page_title) { 'About Us' }

    it_behaves_like "all static pages"
  end

  describe "Contact Page" do
    before { visit contact_path }
    let(:heading)    { 'Contact' }
    let(:page_title) { 'Contact' }

    it_behaves_like "all static pages"
  end


  it "have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_full_title('About Us')
    click_link "Help"
    expect(page).to have_full_title('Help')
    click_link "Contact"
    expect(page).to have_full_title('Contact')
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_full_title('Sign Up')
    click_link "sample app"
    expect(page).to have_full_title('')
  end

end
