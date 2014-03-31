require 'spec_helper'

describe Micropost do

  let(:user) { FactoryGirl.create(:user) }
  before do
    @micropost = user.microposts.build(content: 'Lorem ipsum')
  end

  it { expect(@micropost).to respond_to(:content)}
  it { expect(@micropost).to respond_to(:user_id)}
  it { expect(@micropost).to respond_to(:user)}
  it { expect(@micropost.user).to eq(user)}

  describe 'when user_id is not present' do
    before { @micropost.user_id = nil }
    it { expect(@micropost).not_to be_valid}
  end

  describe 'with blank content' do
    before { @micropost.content = nil }
    it { expect(@micropost).not_to be_valid}
  end

  describe 'with content that is too long' do
    before { @micropost.content = 'a' * 141 }
    it { expect(@micropost).not_to be_valid}
  end
end
