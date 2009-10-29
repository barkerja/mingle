class User < ActiveRecord::Base
  can_be_merged
  
  validates_exclusion_of :username, :in => %w[admin]
  
  has_many :posts
  has_and_belongs_to_many :groups
end

