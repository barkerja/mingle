require 'spec/spec_helper'

describe Mingle do
  describe '#merge' do
    before :each do
      @mike = Factory :user, :username => 'mike'
      @bob  = Factory :user, :username => 'bob', :first_name => 'Bob'
      @band = Factory :artist
    end
    
    it 'requires the target and victim to be of the same type' do
      lambda { @mike.merge @band }.should raise_error(Mingle::IncompatibleTypes)
    end
    
    it 'fills blanks in the target with data from the victim' do
      @mike.first_name.should be_nil
      @mike.merge @bob
      @mike.username.should == 'mike'
      @mike.first_name.should == 'Bob'
    end
    
    describe 'when the target is valid after the merge' do
      it 'saves the target record' do
        @mike.should_receive :save
        @mike.merge @bob
      end
      
      it 'removes the victim from the database' do
        User.count.should == 2
        @mike.merge @bob
        User.count.should == 1
        User.first.should == @mike
      end
      
      it 'removes the victim record using #destroy' do
        @bob.should_receive(:destroy)
        @mike.merge @bob
      end
    end
    
    describe 'when the target is invalid after the merge' do
      before :each do
        @mike.username = 'admin'
        @mike.should_not be_valid
      end
      
      it 'does not save the target record' do
        @mike.should_not_receive :save
        @mike.merge @bob
      end
      
      it 'does not remove the target from the database' do
        @mike.merge @bob
        User.count.should == 2
      end
    end
    
    it 'protects fields passed with :keep' do
      @mike.merge @bob, :keep => :first_name
      @mike.first_name.should be_nil
    end
    
    it 'overwrites fields passed with :overwrite' do
      @mike.merge @bob, :overwrite => :username
      @mike.username.should == 'bob'
    end
  end
end

