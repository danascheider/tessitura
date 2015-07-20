Sequel.migration do 
  up do
    alter_table :listings do
      set_column_allow_null(:title)
    end

    alter_table :tasks do 
      set_column_allow_null(:title)
      set_column_allow_null(:status)
      set_column_allow_null(:priority)
    end
  end

  down do 
    alter_table :listings do
      set_column_not_null(:title)
    end

    alter_table :tasks do 
      set_column_not_null(:title)
      set_column_not_null(:status)
      set_column_not_null(:priority)
    end
  end
end
