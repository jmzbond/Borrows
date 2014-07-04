require 'spec_helper'

describe Inventory do

  	before do
   		@inventory = FactoryGirl.create(:inventory)
  	end

    subject { @inventory }

  	it { should respond_to(:signup_id) }
  	it { should respond_to(:item_name) }
  	it { should respond_to(:description) }

    it { should belong_to(:signup) }
  	it { should be_valid }

    describe "signup_id invalid tests" do
      before { @inventory.signup_id = "" }
      it { should_not be_valid }
    end

    describe "item_name invalid tests" do
      before { @inventory.item_name = "" }
      it { should_not be_valid }
    end

end

