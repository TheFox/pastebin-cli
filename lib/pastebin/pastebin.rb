
require 'net/http'
require 'uri'

module Pastebin
	
	class Pastebin
		
		API_DEV_KEY = 'd46f57321035e4a1eba3ce9b1a70d3cd'
		
		def initialize(options = {})
			if options.nil?
				options = {}
			else
				@options = options
			end
			
			if !@options.has_key?('api_dev_key')
				@options['api_dev_key'] = API_DEV_KEY
			end
			if !@options.has_key?('api_paste_expire_date')
				@options['api_paste_expire_date'] = 'N'
			end
			if !@options.has_key?('api_paste_private')
				@options['api_paste_private'] = '0'
			end
		end
		
		def login(username, password)
			@options['api_user_name'] = username
			@options['api_user_password'] = password
			
			uri = URI.parse('https://pastebin.com/api/api_login.php')
			res = Net::HTTP.post_form(uri, @options)
			
			if res.code.to_i == 200
				if /^[a-f0-9]{32}$/.match(res.body)
					return res.body
				end
			end
			
			raise res.body
		end
		
		def paste
			@options['api_option'] = 'paste'
			
			if @options.has_key?('api_paste_code')
				if @options['api_paste_code'] == '-'
					@options['api_paste_code'] = STDIN.read
				else
					File.open(@options['api_paste_code']) do |file|
						@options['api_paste_code'] = file.read
					end
				end
			else
				@options['api_paste_code'] = STDIN.read
			end
			
			if @options.has_key?('api_paste_code') && @options['api_paste_code']
				uri = URI.parse('https://pastebin.com/api/api_post.php')
				return Net::HTTP.post_form(uri, @options).body
			else
				raise 'no code to paste'
			end
		end
		
		def raw(id)
			uri = URI.parse("https://pastebin.com/raw.php?i=#{id}")
		    Net::HTTP.get_response(uri).body
		end
		
		def print_skel
			puts "API_DEV_KEY=#{API_DEV_KEY}"
			puts 'API_USER_KEY='
			puts 'API_PASTE_EXPIRE_DATE=n'
			puts 'API_PASTE_FORMAT='
			puts 'API_PASTE_PRIVATE=2'
		end
		
		def print_defaults
			puts "API_DEV_KEY=#{@options['api_dev_key']}"
			puts "API_USER_KEY=#{@options['api_user_key']}"
			puts "API_PASTE_EXPIRE_DATE=#{@options['api_paste_expire_date']}"
			puts "API_PASTE_FORMAT=#{@options['api_paste_format']}"
			puts "API_PASTE_PRIVATE=#{@options['api_paste_private']}"
		end
	end
	
end