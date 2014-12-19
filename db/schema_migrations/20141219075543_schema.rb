Sequel.migration do
  change do
    create_table(:auditions) do
      primary_key :id
      String :country, :size=>255
      String :region, :size=>255
      String :city, :size=>255
      Date :date
      DateTime :created_at
      DateTime :updated_at
      Date :deadline
    end
    
    create_table(:listings) do
      primary_key :id
      String :title, :size=>255, :null=>false
      String :web_site, :size=>255, :null=>false
      String :country, :size=>255, :null=>false
      String :region, :size=>255
      String :city, :size=>255, :null=>false
      Date :deadline
      Date :program_start_date, :null=>false
      Date :program_end_date
      String :organization, :size=>255
      String :type, :size=>255
      DateTime :created_at
      DateTime :updated_at
      Integer :min_age
      Integer :max_age
    end
    
    create_table(:users, :ignore_index_errors=>true) do
      primary_key :id
      String :username, :size=>255, :null=>false
      String :password, :size=>255, :null=>false
      String :email, :size=>255, :null=>false
      String :first_name, :size=>255
      String :last_name, :size=>255
      Date :birthdate
      String :city, :size=>255
      String :country, :size=>255
      String :fach, :size=>255
      TrueClass :admin, :default=>false
      DateTime :created_at
      DateTime :updated_at
      
      index [:email], :name=>:email, :unique=>true
      index [:username], :name=>:username, :unique=>true
    end
    
    create_table(:task_lists, :ignore_index_errors=>true) do
      primary_key :id
      foreign_key :user_id, :users, :key=>[:id]
      String :title, :size=>255
      DateTime :created_at
      DateTime :updated_at
      
      index [:user_id], :name=>:user_id
    end
    
    create_table(:tasks, :ignore_index_errors=>true) do
      primary_key :id
      foreign_key :task_list_id, :task_lists, :key=>[:id]
      String :title, :size=>255, :null=>false
      String :status, :default=>"new", :size=>255, :null=>false
      String :priority, :default=>"normal", :size=>255, :null=>false
      DateTime :deadline
      String :description, :text=>true
      Integer :owner_id
      DateTime :created_at
      DateTime :updated_at
      TrueClass :backlog
      Integer :position
      
      index [:task_list_id], :name=>:task_list_id
    end
  end
end
