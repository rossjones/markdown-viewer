require 'sinatra'
require 'rdiscount'

set :public_folder, File.dirname(__FILE__) + '/static'

get '/' do
  @x = 'erb'
  erb :index
end



post '/render' do

  if params[:content]
    content = params[:content]
  else
    content = params['file'][:tempfile].read
  end

  @mdown = content
  @markdown = RDiscount.new(@mdown)
  @result = @markdown.to_html

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

