require 'spec_helper'

describe User do

  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: 'foobar', password_confirmation: 'foobar')
  end

  it { expect(@user).to respond_to(:name)}
  it { expect(@user).to respond_to(:email)}
  it { expect(@user).to respond_to(:password_digest)}
  it { expect(@user).to respond_to(:password)}
  it { expect(@user).to respond_to(:password_confirmation)}
  it { expect(@user).to respond_to(:remember_token)}
  it { expect(@user).to respond_to(:authenticate) }
  it { expect(@user).to respond_to(:admin) }
  it { expect(@user).to respond_to(:microposts) }
  it { expect(@user).to respond_to(:feed) }
  it { expect(@user).to respond_to(:relationships) }
  it { expect(@user).to respond_to(:followed_users) }
  it { expect(@user).to respond_to(:reverse_relationships) }
  it { expect(@user).to respond_to(:followers) }
  it { expect(@user).to respond_to(:following?) }
  it { expect(@user).to respond_to(:follow!) }
  it { expect(@user).to respond_to(:unfollow!) }
  it { expect(@user).to be_valid }
  it { expect(@user).not_to be_admin }

  describe 'micropost associations' do

    before { @user.save }

    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it 'should have the right microposts in the right order' do
      expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
    end

    it 'should destory associated microposts' do
      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        expect(Micropost.where(id: micropost.id)).to be_empty
      end
    end

    describe 'status' do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost,user: FactoryGirl.create(:user))
      end


      it { expect(@user.feed).to include(newer_micropost) }
      it { expect(@user.feed).to include(older_micropost) }
      it { expect(@user.feed).not_to include(unfollowed_post) }
    end

  end

  describe 'with admin attribute set to true' do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { expect(@user).to be_admin }
  end

  describe "when name is not present" do
    before { @user.name = "" }
    it { expect(@user).not_to be_valid}
  end

  describe "when email is not present" do
    before { @user.email = "" }
    it { expect(@user).not_to be_valid}
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { expect(@user).not_to be_valid}
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "email address is already token" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { expect(@user).not_to be_valid }
  end

  describe "when password is not present" do
    before do
      @user_without_pass = User.new(name: "Exmaple User", email: 'user@example.com',
                                    password: ' ', password_confirmation: ' ')
    end
    it { expect(@user_without_pass).not_to be_valid}
  end

  describe "when password doesn't match confirmation" do
    before do
      @user.password_confirmation = 'mismatch'
    end
    it { expect(@user).not_to be_valid }
  end

  describe 'return value of authenticate method' do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe 'with vaild password' do
      it { expect(@user).to eq(found_user.authenticate(@user.password)) }
    end

    describe 'with invaild password' do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }
      it { expect(user_for_invalid_password).not_to eq(@user) }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

  describe 'with a password thats too short' do
    before { @user.password = @user.password_confirmation = 'a' * 5 }
    it { expect(@user).to be_invalid}
  end

  describe 'email addrsss with mixed case' do
    let(:mixied_case_email) { 'Foo@ExAMPle.Com' }

    it 'be saved as all lower-case' do
      @user.email = mixied_case_email
      @user.save
      expect(@user.reload.email).to eq mixied_case_email.downcase
    end
  end

  describe 'following' do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { expect(@user).to be_following(other_user) }
    it { expect(@user.followed_users).to include(other_user) }

    describe 'followed user' do
      it { expect(other_user.followers).to include(@user)}
    end

    describe 'and unfollowing' do
      before { @user.unfollow!(other_user)}

      it { expect(@user).not_to be_following(other_user) }
      it { expect(@user.followed_users).not_to include(other_user) }
    end
  end

end
