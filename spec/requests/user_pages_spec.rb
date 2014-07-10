require 'spec_helper'

describe "UserPages" do
  subject { page }
  describe "signup page" do
  	before {visit signup_path}

  	it { should have_content('Sign up')}
  	it { should have_title(full_title('Sign up')) }
  end
  describe "signup" do
  	before { visit signup_path }
  	let(:submit) { "Create my account" }
  	describe "with invalid information" do
  		it "should not create a user" do
  			expect {click_button submit }.not_to change(User, :count)
  		end
  	end

  	describe "with valid information" do
  		before do
  			fill_in "Name", with: "Example user"
  			fill_in "Email", with: "user@example.com"
  			fill_in "Password", with: "foobar"
  			fill_in "Confirmation", with: "foobar"
  		end
  		it "should create a user" do
  			expect {click_button submit }.to change(User, :count).by(1)
  		end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com')}

        it { should have_link('Sign out')}
        it { should have_link('Settings', href: edit_user_path(user))}
        it { should have_title(user.name)}
        it { should have_selector('div.alert.alert-success', text: 'Welcome')}

        describe "followed by signout" do
          before { click_link 'Sign out'  }
          it { should have_link('Sign in')}
          it { should_not have_link('Settings')}
          it { should_not have_link('Profile')}
        end
      end

  	end
  end


  describe "profile page" do
  	let(:user) { FactoryGirl.create(:user) }
  	before {visit user_path(user)}

  	it { should have_content(user.name)}
  	it { should have_title(user.name)}
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user)}
    before do
     sign_in(user)
     visit edit_user_path(user)
   end

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title('Edit')}
      it { should have_link('Change', href: 'http://gravatar.com/emails') }

      describe "with invalid information" do
        before { click_button "Save Changes" }
        it { should have_content("error")}
      end

      describe "with valid information" do
        let(:new_name)  { "New Name" }
        let(:new_email) { "new@example.com" }
        before do
          fill_in "Name",             with: new_name
          fill_in "Email",            with: new_email
          fill_in "Password",         with: user.password
          fill_in "Confirmation",     with: user.password
          click_button "Save Changes"
        end

        it { should have_title(new_name) }
        it { should have_selector('div.alert.alert-success') }
        it { should have_link('Sign out', href: signout_path) }
        specify { expect(user.reload.name).to  eq new_name }
        specify { expect(user.reload.email).to eq new_email }
      end
    end
  end

  describe "show all" do
    let(:user) { FactoryGirl.create(:user)}
    before do 
      sign_in(user)
      @user1 = FactoryGirl.create(:user, name: "user1", email: "user1@example.com")
      @user2 = FactoryGirl.create(:user, name: "user2", email: "user2@example.com")
      visit users_path
    end

    it { should have_content("All Users")}
    it { should have_title("All Users")}
    it { should have_content(@user1.name)}
    it { should have_content(@user2.name)}
    it { should_not have_link("delete")}

    describe "pagination" do
      before(:all) {30.times { FactoryGirl.create(:user)}}
      after(:all) {User.delete_all}
      it { should have_selector('div.pagination')}

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    describe "with admin priviledges" do
      let(:adminUser) { FactoryGirl.create(:admin)}
      before do
        sign_in(adminUser)
        visit users_path
      end
      it { should have_link("delete", href: user_path(User.first))}
      it "should be able to delete another user" do
        expect{click_link('delete', match: :first)}.to change(User, :count).by(-1)
      end
    end
  end
end
