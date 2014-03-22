include ApplicationHelper

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :have_full_title do |message|
  match do |page|
    expect(page).to have_title(full_title(message))
  end
end

def valid_signin(user)
  fill_in "Email", with: user.email.upcase
  fill_in "Password", with: user.password
  click_button 'Sign in'
end
