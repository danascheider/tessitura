module DashboardHelper

  def widget_tag(opts = {})
    @title = opts[:title]
    @icon_class = opts[:icon_class]
    @partial = opts[:partial]
    @widget_id = opts[:id]
    render 'widget'
  end

  def icon_tag(icon_class)
    tag("i", class: icon_class) + tag("/i")
  end
end
