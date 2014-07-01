require 'spec_helper'

describe User do
  before { @sampleUser = User.new(name: "Example User", 
                                  email: "user@example.com", 
                                  password: "foobar", 
                                  password_confirmation: "foobar")}
  subject { @sampleUser }
  it { should respond_to(:name) }
  it { should respond_to(:email)}
  it { should respond_to(:password_digest)}
  #virtual attributes
  it { should respond_to(:password)}
  it { should respond_to(:password_confirmation)}
  it { should respond_to(:authenticate)}
  it { should respond_to(:remember_token)}

  it {should be_valid }

  describe "when name is not present" do
  	before {@sampleUser.name = " " }
  	it {should_not be_valid }
  end

  describe "when email is not prsent" do
  	before { @sampleUser.email = "" }
  	it {should_not be_valid }
  end

  describe "when name is too long " do
  	before { @sampleUser.name = ("a" * 51) }
  	it { should_not be_valid }
  end

  describe "when email format is valid" do
  	addresses = %w[user@foo.COM A_US_ER@f.b.org frst.1st@foo.jp a+b@baz.cn]
  	 addresses.each do |valid_address|
  		before { @sampleUser.email = valid_address }
  		it { should be_valid }
  	end
  end

  describe "when email format is invalid" do
    addresses = %w[user@foo,com user_at_foo.org foo@bar+baz.com foo@bar..com]
     addresses.each do |invalid_address|
      before { @sampleUser.email = invalid_address }
      it { should_not be_valid }
    end
  end

  describe "when email is duplicated" do
  	before do 
  		duplicatedEmail = @sampleUser.dup 
  		duplicatedEmail.email.upcase!
  		duplicatedEmail.save 
  	end

  	it { should_not be_valid }
  end

  describe "when emails are uppercased" do
    before do 
      @duplicatedEmail = @sampleUser.dup 
      (@duplicatedEmail.email + "randomString").upcase!
      @duplicatedEmail.save 
    end
    it { (@duplicatedEmail.email).should == (@duplicatedEmail.email.downcase) }
  end

  describe "when password is not present" do
    before { @sampleUser = User.new(name: "Sample",
                                    email: "sample@samplecom",
                                    password: " ",
                                    password_confirmation: " ")}
    it {should_not be_valid}
  end
  describe "when password is not present" do
    before { @sampleUser.password_confirmation = "mismatch" }
    it {should_not be_valid}
  end

  describe "return the value of authenticate method" do
    before { @sampleUser.save }
    let(:found_user) { User.find_by(email: @sampleUser.email) }
    describe "with valid password" do
      it { should eq found_user.authenticate(@sampleUser.password) }
    end

    describe "without valid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalidPassword")}
      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end

    describe "with a password that's too short" do
      before { @sampleUser.password = @sampleUser.password_confirmation = 'a' * 5}
      it { should_not be_valid}
    end
  end

  describe "remember token" do
    before { @sampleUser.save }
    its(:remember_token) { should_not be_blank }
  end

end
