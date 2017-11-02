#Copyright Alexander Hammond January 16, 2017

require 'json'

class User < ActiveRecord::Base
	has_many :items
	#Calls set_default_values after it has finished initializing
	after_initialize :set_default_values, if: :new_record?

	#Before it creates the object it calls the build_defaults
	before_create :build_defaults


	#These methods are standard for building Rails databases
	private
		
		def set_default_values
		end
		
		def build_defaults
		end
end

