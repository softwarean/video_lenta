Airbrake.configure do |config|
	config.api_key	= '3c6c0888bc3c2384cbfe8340c7998bc2'
	config.host	= 'errbit.undev.cc'
	config.port	= 80
	config.secure	= config.port == 443
end
