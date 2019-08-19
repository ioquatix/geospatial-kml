
require 'geospatial/kml/reader'

RSpec.describe Geospatial::KML::Reader do
	let(:kml_path) {File.join(__dir__, "christchurch.kml")}
	let(:reader) {Geospatial::KML::Reader.load_file(kml_path)}
	let(:center) {Vector[172.638216, -43.526326]}
	
	it "should have one polygon" do
		expect(reader.polygons.count).to be == 1
		expect(reader.polygons.first).to be_kind_of Geospatial::Polygon
		expect(reader.polygons.first).to be_include_point center
	end
	
	let(:placemark) {reader.placemarks.first}
	
	it "can get extended data" do
		expect(placemark.extended_data[:id]).to be == '1'
		expect(placemark.extended_data.to_h).to be == {id: '1'}
	end
end
