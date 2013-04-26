class CreateInvites < ActiveRecord::Migration
  def self.up
    create_table :invites do |t|
      t.column :user_id, :integer, :default => false
      t.column :email, :string
      t.column :source_id, :string
      t.column :source, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :invites
  end
end
