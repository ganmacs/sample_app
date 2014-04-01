require 'spec_helper'

describe Relationship do

  let(:follower) { FactoryGirl.create(:user) }
  let(:followed) { FactoryGirl.create(:user) }
  let(:relationship) { follower.relationships.build(followed_id: followed.id) }

  it { expect(relationship).to be_valid }

  describe 'follower methods' do
    it { expect(relationship).to respond_to(:follower) }
    it { expect(relationship).to respond_to(:followed) }
    it { expect(relationship.follower).to eq(follower)}
    it { expect(relationship.followed).to eq(followed)}

  end

  describe 'when followerd id is not present' do
    before { relationship.followed_id = nil }
    it { expect(relationship).not_to be_valid }
  end

  describe 'when follower id is not present' do
    before { relationship.followed_id = nil}
    it { expect(relationship).not_to be_valid }
  end
end
