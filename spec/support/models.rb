require 'active_record'

begin
  ActiveRecord::Base.establish_connection
  connection = ActiveRecord::Base.connection

  connection.drop_table :users rescue nil
  connection.create_table :users
end

class User < ActiveRecord::Base; end
