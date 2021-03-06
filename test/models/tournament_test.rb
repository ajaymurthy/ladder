require "minitest_helper"

describe Tournament do
  describe ".create" do
    it "will only allow owner to have a limited number" do
      @user = create(:user)
      @tournaments = create_list(:tournament, 5, :owner => @user)
      @tournament = @user.tournaments.create(attributes_for(:tournament))
      @tournament.errors.size.must_equal 1
    end
  end

  describe ".participant" do
    before do
      @user = create(:user)
      @tournament = create(:tournament)
    end

    it "wont match users who are unrelated" do
      Tournament.participant(@user).wont_include @tournament
    end

    it "must match users who are owners" do
      @tournament.update_attribute(:owner, @user)
      Tournament.participant(@user).must_include @tournament
    end

    it "must match users who are ranked" do
      create(:rank, :tournament => @tournament, :user => @user)
      Tournament.participant(@user).must_include @tournament
    end

    it "must match users who accepted an invite" do
      create(:invite, :tournament => @tournament, :user => @user)
      Tournament.participant(@user).must_include @tournament
    end
  end

  describe "#has_user?" do
    before do
      @tournament = create(:tournament)
      @users = create_list(:user, 2)
      @rank = create(:rank, :user => @users.first, :tournament => @tournament)
    end

    it "must match users who are participating" do
      @tournament.has_user?(@users.first).must_equal true
    end

    it "wont match users who are not participating" do
      @tournament.has_user?(@users.last).must_equal false
    end
  end
end
