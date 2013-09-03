# Copyright 2011-2013 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You
# may not use this file except in compliance with the License. A copy of
# the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
# ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require File.expand_path(File.dirname(__FILE__) + '/load_config')

p "setting up proxy..."
AWS.config(:proxy_uri => 'http://liuyb:Adplucky22@dc01proxy.ga.adp.com:8080')


# get an instance of the S3 interface using the default configuration
s3 = AWS::S3.new

p "getting s3 instance..."
p s3

s3.buckets.each do |bucket|
  puts bucket.name
end

cdn_b=s3.buckets['tscdn.adp']
p cdn_b

# enumerate at most 20 objects with the given prefix
cdn_b.objects.with_prefix('tscdn2013-08-2').each(:limit => 200) do |cdn_file|
  puts cdn_file.key
  # streaming download from S3 to a file on disk
  local_file_name = './download/'+cdn_file.key+'.txt'
  p local_file_name

  File.open(local_file_name, 'wb') do |file|
    cdn_file.read do |chunk|
    file.write(chunk)
  end

  # File.rename( local_file_name, './download/'+local_file_name)
end


end



