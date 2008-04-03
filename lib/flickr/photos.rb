class Flickr::Photos < Flickr::Base
  def initialize(flickr)
    @flickr = flickr
  end

  # Return a list of photos matching some criteria. Only photos visible to the calling user will be returned. To return private or semi-private photos, 
  # the caller must be authenticated with 'read' permissions, and have permission to view the photos. Unauthenticated calls will only return public photos.
  # 
  # == Authentication
  # This method does not require authentication.
  # 
  # == Options
  # * user_id (Optional)
  #     The NSID of the user who's photo to search. If this parameter isn't passed then everybody's public photos will be searched. A value of "me" will 
  #     search against the calling user's photos for authenticated calls.
  # * tags (Optional)
  #     A comma-delimited list of tags. Photos with one or more of the tags listed will be returned.
  # * tag_mode (Optional)
  #     Either 'any' for an OR combination of tags, or 'all' for an AND combination. Defaults to 'any' if not specified.
  # * text (Optional)
  #     A free text search. Photos who's title, description or tags contain the text will be returned.
  # * min_upload_date (Optional)
  #     Minimum upload date. Photos with an upload date greater than or equal to this value will be returned. The date should be in the form of a unix timestamp.
  # * max_upload_date (Optional)
  #     Maximum upload date. Photos with an upload date less than or equal to this value will be returned. The date should be in the form of a unix timestamp.
  # * min_taken_date (Optional)
  #     Minimum taken date. Photos with an taken date greater than or equal to this value will be returned. The date should be in the form of a mysql datetime.
  # * max_taken_date (Optional)
  #     Maximum taken date. Photos with an taken date less than or equal to this value will be returned. The date should be in the form of a mysql datetime.
  # * license (Optional)
  #     The license id for photos (for possible values see the flickr.photos.licenses.getInfo method). Multiple licenses may be comma-separated.
  # * sort (Optional)
  #     The order in which to sort returned photos. Deafults to date-posted-desc. The possible values are: date-posted-asc, date-posted-desc, date-taken-asc, 
  #     date-taken-desc, interestingness-desc, interestingness-asc, and relevance.
  # * privacy_filter (Optional)
  #     Return photos only matching a certain privacy level. This only applies when making an authenticated call to view photos you own. Valid values are:
  #       1 public photos
  #       2 private photos visible to friends
  #       3 private photos visible to family
  #       4 private photos visible to friends & family
  #       5 completely private photos
  # * bbox (Optional)
  #     A comma-delimited list of 4 values defining the Bounding Box of the area that will be searched. 
  # 
  #     The 4 values represent the bottom-left corner of the box and the top-right corner, minimum_longitude, minimum_latitude, maximum_longitude, maximum_latitude. 
  # 
  #     Longitude has a range of -180 to 180 , latitude of -90 to 90. Defaults to -180, -90, 180, 90 if not specified. 
  # 
  #     Unlike standard photo queries, geo (or bounding box) queries will only return 250 results per page. 
  # 
  #     Geo queries require some sort of limiting agent in order to prevent the database from crying. This is basically like the check against "parameterless searches" 
  #     for queries without a geo component. 
  # 
  #     A tag, for instance, is considered a limiting agent as are user defined min_date_taken and min_date_upload parameters — If no limiting factor is passed we 
  #     return only photos added in the last 12 hours (though we may extend the limit in the future).
  # * accuracy (Optional)
  #     Recorded accuracy level of the location information. Current range is 1-16 :
  #       World level is 1
  #       Country is ~3
  #       Region is ~6
  #       City is ~11
  #       Street is ~16
  #     Defaults to maximum value if not specified.
  # * safe_search (Optional)
  #     Safe search setting:
  #       1 for safe.
  #       2 for moderate.
  #       3 for restricted.
  #     (Please note: Un-authed calls can only see Safe content.)
  # * content_type (Optional)
  #     Content Type setting:
  #       1 for photos only.
  #       2 for screenshots only.
  #       3 for 'other' only.
  #       4 for photos and screenshots.
  #       5 for screenshots and 'other'.
  #       6 for photos and 'other'.
  #       7 for photos, screenshots, and 'other' (all).
  # * machine_tags (Optional)
  #     Aside from passing in a fully formed machine tag, there is a special syntax for searching on specific properties :
  #       Find photos using the 'dc' namespace : "machine_tags" => "dc:"
  #       Find photos with a title in the 'dc' namespace : "machine_tags" => "dc:title="
  #       Find photos titled "mr. camera" in the 'dc' namespace : "machine_tags" => "dc:title=\"mr. camera\"
  #       Find photos whose value is "mr. camera" : "machine_tags" => "*:*=\"mr. camera\""
  #       Find photos that have a title, in any namespace : "machine_tags" => "*:title="
  #       Find photos that have a title, in any namespace, whose value is "mr. camera" : "machine_tags" => "*:title=\"mr. camera\""
  #       Find photos, in the 'dc' namespace whose value is "mr. camera" : "machine_tags" => "dc:*=\"mr. camera\""
  #     Multiple machine tags may be queried by passing a comma-separated list. The number of machine tags you can pass in a single query depends on 
  #     the tag mode (AND or OR) that you are querying with. "AND" queries are limited to (16) machine tags. "OR" queries are limited to (8).
  # * machine_tag_mode (Required)
  #     Either 'any' for an OR combination of tags, or 'all' for an AND combination. Defaults to 'any' if not specified.
  # * group_id (Optional)
  #     The id of a group who's pool to search. If specified, only matching photos posted to the group's pool will be returned.
  # * woe_id (Optional)
  #     A 32-bit identifier that uniquely represents spatial entities. (not used if bbox argument is present). Experimental. 
  # 
  #     Geo queries require some sort of limiting agent in order to prevent the database from crying. This is basically like the check against "parameterless searches" 
  #     for queries without a geo component. 
  # 
  #     A tag, for instance, is considered a limiting agent as are user defined min_date_taken and min_date_upload parameters &emdash; If no limiting factor is passed 
  #     we return only photos added in the last 12 hours (though we may extend the limit in the future).
  # * place_id (Optional)
  #     A Flickr place id. (not used if bbox argument is present). Experimental. 
  # 
  #     Geo queries require some sort of limiting agent in order to prevent the database from crying. This is basically like the check against "parameterless searches" 
  #     for queries without a geo component. 
  # 
  #     A tag, for instance, is considered a limiting agent as are user defined min_date_taken and min_date_upload parameters &emdash; If no limiting factor is passed 
  #     we return only photos added in the last 12 hours (though we may extend the limit in the future).
  # * extras (Included Automatically)
  #     A comma-delimited list of extra information to fetch for each returned record.
  # 
  #     Currently supported fields are: 
  #       license
  #       date_upload
  #       date_taken
  #       owner_name
  #       icon_server
  #       original_format
  #       last_update
  #       geo
  #       tags
  #       machine_tags
  #       o_dims
  #       views
  # * per_page (Optional)
  #     Number of photos to return per page. If this argument is omitted, it defaults to 100. The maximum allowed value is 500.
  # * page (Optional)
  #     The page of results to return. If this argument is omitted, it defaults to 1.
  # 
  def search(options)
    options = {:extras => "license,date_upload,date_taken,owner_name,icon_server,original_format,last_update,geo,tags,machine_tags,o_dims,views"}.merge(options)

    rsp = @flickr.send_request('flickr.photos.search', options)

    returning PhotoResponse.new(:page => rsp.photos[:page].to_i,
                                :pages => rsp.photos[:pages].to_i,
                                :per_page => rsp.photos[:perpage].to_i,
                                :total => rsp.photos[:total].to_i,
                                :photos => [], :api => self,
                                :method => 'flickr.photos.search',
                                :options => options) do |photos|
      rsp.photos.photo.each do |photo|
        attributes = {:id => photo[:id], 
                      :owner => photo[:owner], 
                      :secret => photo[:secret], 
                      :server => photo[:server], 
                      :farm => photo[:farm], 
                      :title => photo[:title], 
                      :is_public => photo[:ispublic], 
                      :is_friend => photo[:isfriend], 
                      :is_family => photo[:isfamily],
                      :license => photo[:license],
                      :uploaded_at => (Time.at(photo[:dateupload].to_i) rescue nil),
                      :taken_at => (Time.parse(photo[:datetaken]) rescue nil),
                      :owner_name => photo[:ownername],
                      :icon_server => photo[:icon_server],
                      :original_format => photo[:originalformat],
                      :updated_at => (Time.at(photo[:lastupdate].to_i) rescue nil),
                      :geo => photo[:geo],
                      :tags => photo[:tags],
                      :machine_tags => photo[:machine_tags],
                      :o_dims => photo[:o_dims],
                      :views => photo[:views].to_i}

        photos << Photo.new(@flickr, attributes)
      end if rsp.photos.photo
    end
  end

  # wrapping class to hold a photos response from the flickr api
  class PhotoResponse
    attr_accessor :page, :pages, :per_page, :total, :photos, :api, :method, :options
    
    # creates an object to hold the search response.
    # 
    # Params
    # * attributes (Required)
    #     a hash of attributes used to set the initial values of the response object
    def initialize(attributes)
      attributes.each do |k,v|
        send("#{k}=", v)
      end
    end

    # Add a Flickr::Photos::Photo object to the photos array.  It does nothing if you pass a non photo object
    def <<(photo)
      self.photos ||= []
      self.photos << photo if photo.is_a?(Flickr::Photos::Photo)
    end

    # gets the next page from flickr if there are anymore pages in the current photos object
    def next_page
      api.send(self.method.split('.').last, options.merge(:page => self.page.to_i + 1)) if self.page.to_i < self.pages.to_i
    end

    # gets the previous page from flickr if there is a previous page in the current photos object
    def previous_page
      api.send(self.method.split('.').last, options.merge(:page => self.page.to_i - 1)) if self.page.to_i > 1
    end
    
    # passes all unknown request to the photos array if it responds to the method
    def method_missing(method, *args, &block)
      self.photos.respond_to?(method) ? self.photos.send(method, *args, &block) : super
    end
  end
end
