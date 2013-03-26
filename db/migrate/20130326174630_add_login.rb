class AddLogin < ActiveRecord::Migration
  def self.up
    add_column    :demands, :login, :string, :after => :service
  end

  def self.down
    remove_column :demands, :login
  end
end
