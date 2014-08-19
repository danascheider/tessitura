shared_examples 'a filter' do 
  let(:filter) { TaskFilter.new(conditions, @list.owner_id) }
  let(:filtered_tasks) { filter.filter }

  it 'returns an ActiveRecord relation' do 
    expect(filtered_tasks).to be_an(ActiveRecord::Relation)
  end

  it 'returns the tasks fulfilling the conditions' do 
    expect(filtered_tasks.to_set & included_tasks.to_set).to eql included_tasks.to_set
  end

  it 'excludes the tasks not fulfilling the conditions' do 
    expect(filtered_tasks.to_set & excluded_tasks.to_set).to eql [].to_set
  end
end