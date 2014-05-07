json.array!(@categorizations) do |categorization|
  json.extract! categorization, :id, :todo_id, :category_id
  json.url categorization_url(categorization, format: :json)
end
