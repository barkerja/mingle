ActiveRecord::Schema.define do
  create_table :artists, :force => true do |t|
    t.string :name
  end
  
  create_table :groups, :force => true do |t|
    t.string :title
  end
  
  create_table :groups_users, :id => false, :force => true do |t|
    t.belongs_to :group
    t.belongs_to :user
  end
  
  create_table :posts, :force => true do |t|
    t.string :author
    t.string :title
    t.belongs_to :user
  end
  
  create_table :trackings, :force => true do |t|
    t.belongs_to :user
    t.belongs_to :artist
  end
  
  create_table :users, :force => true do |t|
    t.string :username
    t.string :first_name
  end
end

