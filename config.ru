use Rack::Static,
  :urls => %w(/stylesheets /javascripts /images),
  :root => Dir.pwd + '/public'

run lambda { |env|
  [ 200, { 'Content-Type' => 'text/html' }, File.open('public/index.html') ]
}
