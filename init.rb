# Include hook code here
# TODO Article
if ENV['RAILS_ENV'] == 'test'
  puts "LOADING ACTIVE RECORD LIKE" 
  $LOAD_PATH << File.dirname(__FILE__) + '/test' 
end

ActiveSupport::Dependencies.load_paths = $LOAD_PATH   
require 'active_record_like'