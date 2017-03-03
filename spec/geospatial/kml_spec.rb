require "spec_helper"
require 'irb'

require 'geospatial/kml/reader'

RSpec.describe Geospatial::KML do
	let(:kml_path) {File.join(__dir__, "christchurch.kml")}
	let(:reader) {Geospatial::KML::Reader.load_file(kml_path)}
	
	it "should have one polygon" do
		binding.irb
		
		expect(reader.polygons.count).to be == 1
	end
end
