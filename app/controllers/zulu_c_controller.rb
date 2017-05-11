require "pp"

class ZuluCController < ApplicationController

  Expedia.cid = 501048
  Expedia.api_key = '60nn3elg2bfbcs1lsrmqu1l1oo'
  Expedia.shared_secret = '3aaamcg1f416l'
  Expedia.locale = 'en_US'
  Expedia.currency_code = 'USD'
  Expedia.minor_rev = 30
  Expedia.use_signature = true # must be false if using ip whitelisting instead of signature
  # Optional configuration...
  Expedia.timeout = 1 # read timeout in sec
  Expedia.open_timeout = 1 # connection timeout in sec

  def index
  end

  def api_test
  	api = Expedia::Api.new
  	response = api.get_list({
  		:city => "Las Vegas", 
  		# :stateProvinceCode => "NV",
  		# :countryCode => "US",
  		:arrivalDate => "5/25/2017",
  		:departureDate => "6/1/2017",
  		:room1 => "2,6,6"
  		})
  	
  	p "$" * 50
  	pp response
  	p "$" * 50

  	if response.respond_to?(:body)
	  	render :json => response.body["HotelListResponse"]["HotelList"]["HotelSummary"][0...10]
	else
		render :json => response.error_body
	end
  end

  def ean
  	def fix_date(d)
  		# The EAN platform wants dates in mm/dd/yyyy format, but the HTML date input sends them as yyyy-mm-dd
  		date_regex = /(\d\d\d\d)-(\d\d)-(\d\d)/
  		m = date_regex.match(d)
  		# p m 
  		if !m.nil?
  			return "#{m[2]}/#{m[3]}/#{m[1]}"
  		else
  			return ""
  		end
  	end
  	
  	p "$" * 50
  	pp params
  	p "$" * 50

  	if params[:city].to_s.empty?
  		render :json => false
  		return
  	end

  	# render :json => params
  	api = Expedia::Api.new
  	response = api.get_list({
  		:city => params[:city], 
  		# :stateProvinceCode => "NV",
  		# :countryCode => "US",
  		:arrivalDate => fix_date(params[:arriving]),
  		:departureDate => fix_date(params[:departing]),
  		:room1 => params[:adults] == "# Adults" ? 1 : params[:adults]
  		})

  	if response.respond_to?(:body)
	  	render :json => response.body["HotelListResponse"]["HotelList"]["HotelSummary"][0...10]
	else
		render :json => response.error_body
	end

 #  	if response["body"]
	#   	render :json => response.body["HotelListResponse"]["HotelList"]["HotelSummary"][0...5]
	# else
	#   	render :json => response
	# end
  end
end
