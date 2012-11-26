require 'sinatra'
require 'rdiscount'

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

not_found do
  erb :not_found
end

# Handle the other pages by directly rendering the appropriate template
# Prone to failure
get '/?:page?' do
  begin
    erb params['page'].to_sym
  rescue Errno::ENOENT
    raise Sinatra::NotFound
  end
end

