require 'sinatra'
require 'rdiscount'

configure :productiondo
    enable :logging
end

def render_md(params, forced=nil)
  @mdown =  forced ? forced : (params[:content] ? params[:content] : params['file'][:tempfile].read)
  return RDiscount.new(@mdown).to_html, @mdown
end

get '/' do
  @mdown = erb :default_content,:layout=>false
  @result, _ = render_md params, @mdown
  erb :index
end

post '/' do
  @result, @mdown = render_md params
  @encoded = params[:encode]

  if params[:site]
    erb :index
  else
    content_type 'text/plain', :charset => 'utf-8'
    @result
  end
end

# Handle the other pages by directly rendering the appropriate
# template
get '/?:page?' do
  erb params['page'].to_sym
end

