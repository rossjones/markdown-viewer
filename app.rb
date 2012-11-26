require 'sinatra'
require 'rdiscount'

def render_md(params, forced=nil)
  @mdown =  forced ? forced : (params[:content] ? params[:content] : params['file'][:tempfile].read)
  return RDiscount.new(@mdown).to_html, @mdown
end

get '/' do
      @mdown = <<HERE
# Using Markdown Viewer

Paste your Markdown into this text area, and then click *Show me HTML!* to see what the rendered output looks like.  If you want the HTML source then click *Give me HTML!*

## Using curl

If you want to use curl to convert your Markdown you can POST to http://markdownviewer.herokuapp.com/render passing your Markdown in a variable called _content_.

> curl --data "content=#This is a title" http://markdownviewer.herokuapp.com/render

To send a file (with your Markdown in) use the following, replacing filename.txt with the name of your file

> curl --form "file=@filename.txt" http://markdownviewer.herokuapp.com/render
HERE
  @result, _ = render_md params, @mdown
  erb :index
end

post '/' do
  @result,@mdown = render_md params

  if params[:encode]
    @encoded = true
  end

  if params[:site]
    erb :index
  else
    content_type 'text/plain', :charset => 'utf-8'
    @result
  end

end

