require 'rubygems'
require 'mongo'
require 'json'
require 'time'

include Mongo



class MongoProcessor

  @@mongo_host = "localhost"
  @@mongo_port = 27017

  @@get_request_tag = "REST.GET.OBJECT ts-videos/"

  def initialize()
    mongo_client = MongoClient.new(@@mongo_host, @@mongo_port)
    # mongo_client.database_info.each { |info| p info.inspect }
    db = mongo_client.db("cdn_logs")
    @requests = db.collection("get_requests")

  end


  def process()

    Dir.glob("./test/*.txt") do |item|
      next if item == '.' or item == '..'
      p "process starting..."
      line_num=0
      File.open( item ).each do |line|
        print "#{line_num += 1} #{line}"
        # p "start line processing..."
        line = line.force_encoding("iso-8859-1")
        # log_sections = line.strip().force_encoding("iso-8859-1").split(' ')
        start_index = line.index(@@get_request_tag)
        if(start_index && start_index>0 )
          start_index = start_index+@@get_request_tag.length
          end_index = line.index("GET", start_index )
          name_length = end_index - start_index-2
          p name_length
          video_name = line[start_index, name_length]
          p video_name

          time_start =   line.index('[')+1
          time_length = line.index(']') - time_start-6
          time_value = line[time_start, time_length]
          p time_value


          time_forhash = Time.strptime(time_value,"%d/%b/%Y:%H:%M:%S").utc
          p time_forhash

          request_hash = { "time"=>time_forhash, "video"=>video_name, "log"=>line}
          p request_hash

          id = @requests.insert(request_hash)



        end

      end

    end


  end


end

mp = MongoProcessor.new
mp.process()


