require 'spec_helper'

describe "UserPages" do

  describe "signup page" do
    before { visit signup_path }

    it { expect(page).to have_content('Sign Up')}
    it { expect(page).to have_title(full_title('Sign Up'))}
  end
end
