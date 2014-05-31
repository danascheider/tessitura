require 'spec_helper'

describe "tasks/show" do
  before(:each) do
    @task = assign(:task, stub_model(Task,
      :title => "Title", :complete => false
    ))
  end

  it "renders attributes in <table>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
  end

  it "displays status in human language" do 
    render 
    assert_select "tr>td", text: "Incomplete"
  end
end
