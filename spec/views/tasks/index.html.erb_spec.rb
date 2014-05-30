require 'spec_helper'

describe "tasks/index" do
  before(:each) do
    assign(:tasks, [
      stub_model(Task,
        :title => "Title"
      ),
      stub_model(Task,
        :title => "Title"
      )
    ])
  end

  it "renders a list of tasks" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
  end

  describe "when there are no tasks" do 

    # Make sure task list is empty
    before(:each) do 
      Task.all == nil
    end

    it "displays a message that there are no tasks" do 
      assert_select "p", text: 'No tasks!'
    end
  end
end
