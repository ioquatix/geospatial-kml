
require 'geospatial/kml/reader'

RSpec.describe Geospatial::KML::Reader do
	let(:kml_path) {File.join(__dir__, "christchurch.kml")}
	let(:reader) {Geospatial::KML::Reader.load_file(kml_path)}
	
	it "should have one polygon" do
		expect(reader.polygons.count).to be == 1
	end
end
