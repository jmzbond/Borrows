require 'spec_helper'


describe Request do

  	before do
   		@request = FactoryGirl.create(:request)
  	end

    subject { @request }

  	it { should respond_to(:email) }
  	it { should respond_to(:item) }
  	it { should respond_to(:detail) }
  	it { should respond_to(:name) }
    it { should respond_to(:rentdate) }
    it { should respond_to(:paydeliver) }
  	it { should respond_to(:edit_id) } #model logic auto-creates this

  	it { should be_valid }

	describe "when name is not present" do
    	before { @request.name = " " }
    	it { should_not be_valid }
 	end
  
	describe "when name is too long" do
	    before { @request.name = "a" * 51 }
	    it { should_not be_valid }
	end

  describe "when there is only a first name" do
    before { @request.name = Faker::Name.first_name }
    it { should_not be_valid }
  end

  describe "when there is only a last name" do
    before { @request.name = Faker::Name.last_name }
    it { should_not be_valid }
  end

  describe "when there is an appropriate first and last name" do
    before { @request.name = Faker::Name.name }
    it { should be_valid }
  end

  	describe "when email is not present" do
    	before { @request.email = " " }
    	it { should_not be_valid }
 	  end

    describe "when email format is invalid" do
   		it "should be invalid" do
	      	addresses = %w[user@foo..com, user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
	      	addresses.each do |invalid_address|
	        	@request.email = invalid_address
	        	expect(@request).not_to be_valid
	      	end
    	end
  	end

  	describe "when email format is valid" do
   		it "should be valid" do
	        addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
	        addresses.each do |valid_address|
        		@request.email = valid_address
       			expect(@request).to be_valid
      		end
    	end

      before { @request.email = Faker::Internet.email }
      it { should be_valid }
  	end

  	describe "when item is not present" do
  		before { @request.item = "" }
  		it { should_not be_valid }
  	end

    describe "when item is present" do
      before { @request.item = "random" }
      it { should be_valid }
    end

  	describe "when detail is not present" do
  		before { @request.detail = "" }
  		it { should_not be_valid }
  	end

    describe "when detail is present" do
      before { @request.detail = "random text" }
      it { should be_valid }
    end

    describe "when rentdate is not present" do
      before { @request.rentdate = "" }
      it { should_not be_valid }
    end

    describe "when rentdate is present" do
      before { @request.rentdate = "random text" }
      it { should be_valid }
    end

    describe "when paydeliver is not present" do
      before { @request.paydeliver = "" }
      it { should_not be_valid }
    end

    describe "when paydeliver is present" do
      before { @request.paydeliver = true }
      it { should be_valid }

      describe "when addysdeliver is present" do
        before { @request.addysdeliver = "random text" }
        it { should be_valid }
      end

      describe "when addysdeliver is not present" do
        before { @request.addysdeliver = "" }
        it { should_not be_valid }
      end

      describe "when timedeliver is present" do
        before { @request.timedeliver = "random text" }
        it { should be_valid }
      end

      describe "when timedeliver is not present" do
        before { @request.timedeliver = "" }
        it { should_not be_valid }
      end

      describe "when insrucdeliver is present" do
        before { @request.insrucdeliver = "random text" }
        it { should be_valid }
      end

      describe "when insrucdeliver is not present" do
        before { @request.insrucdeliver = "" }
        it { should be_valid }
      end
    end
end

