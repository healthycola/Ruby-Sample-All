require 'spec_helper'

describe "Static pages" do
  
  let(:title_Begin) {'RoRT'}
  describe "Home pages" do
    before { visit root_path }
    subject { page }
    it { should have_content('Sample App')}
    it { should have_title("#{title_Begin}") }
    it { should_not have_title(': Home') }
  end

  describe "Help page" do
    before {visit help_path}
    subject { page }
  	it {should have_content('Help')}
  	it {should have_title("#{title_Begin}: Help")}
  end

  describe "About page" do
    before {visit about_path}
    subject { page }
  	it {should have_content('About Us')}
  	it {should have_title("#{title_Begin}: About")}
  end

  describe "Contact page" do
    before {visit contact_path}
    subject { page }
  	it {should have_content('Contact Us')}
  	it {should have_title("#{title_Begin}: Contact")}
  end
end
