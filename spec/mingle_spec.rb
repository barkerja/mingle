require File.dirname(__FILE__) + '/spec_helper'

describe Mingle do
  describe '#merge' do
    before :each do
      @mike = Factory(:user, :username => 'mike')
      @bob  = Factory(:user, :username => 'bob', :first_name => 'Bob')
    end
    
    it 'fills blanks in the target with data from the victim' do
      @mike.first_name.should be_nil
      @mike.merge @bob
      @mike.username.should == 'mike'
      @mike.first_name.should == 'Bob'
    end
    
    it 'saves the target record' do
      @mike.merge @bob
      @mike.reload
      @mike.first_name.should == 'Bob'
    end
  end
end

