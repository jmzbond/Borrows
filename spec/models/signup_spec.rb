require 'spec_helper'


describe Signup do

  subject { @signup }

  describe "mimic create action" do

  	before do
   		@signup = FactoryGirl.build(:signup_email)
  	end

  	it { should respond_to(:email) }
    it { should respond_to(:last_emailed_on)}

    it { should be_valid }

  	describe "email invalid tests" do
      # blank email
  	  before { @signup.email = " " }
      it { should_not be_valid }

      # invalid format email
      addresses = %w[user@foo..com, user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        before { @signup.email = invalid_address }
        it { should_not be_valid }
      end
    end

    describe "email valid tests" do 
      #valid format 
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
    		before { @signup.email = valid_address }
   			it { should be_valid }
  		end
    end

    describe "email downcasing" do 
      before do
        @new_signup = Signup.create(email: "HOLYCRAP_perS@Gmail.com", streetone: "Post", streettwo: "Taylor", zipcode: 94109, tos: true)
      end
      
      it "should be downcased and valid" do
        @new_signup.email.should eq("holycrap_pers@gmail.com") 
        @new_signup.should be_valid
      end
    end

    describe "mimic update action" do

      before do
        @signup.update_attributes(streetone: "Post", streettwo: "Taylor", zipcode: 94109, tos: true)
      end

      it { should respond_to(:email) }
      it { should respond_to(:streetone) }
      it { should respond_to(:streettwo) }
      it { should respond_to(:zipcode) }
      it { should respond_to(:heard) }
      it { should respond_to(:tos) }
      
      it { should be_valid }

      describe "cross streets invalid tests" do
        before { @signup.streetone = " " }
        it { should_not be_valid }

        before { @signup.streettwo = " " } 
        it { should_not be_valid }
        
        before { @signup.streetone = "Post" }
        before { @signup.streetone = @signup.streettwo }
        it { should_not be_valid }
      end

      describe "zipcode invalid tests" do
        before { @signup.zipcode = nil}
        it { should_not be_valid }
        
        before { @signup.zipcode = 123 }
        it { should_not be_valid }
        
        before { @signup.zipcode = -123 }
        it { should_not be_valid }
        
        before { @signup.zipcode = 123456 }
        it { should_not be_valid }
      end

      describe "tos invalid tests" do
        before { @signup.tos = "" }
        it { should_not be_valid }

        before { @signup.tos = false }
        it { should_not be_valid }
      end
    end
  end
end
