# Copyright, 2018, by Samuel G. D. Williams. <http://www.codeotaku.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'nokogiri'

require 'geospatial/location'
require 'geospatial/circle'
require 'geospatial/polygon'

module Geospatial
	module KML
		class Placemark
			def initialize(node)
				@node = node
			end
			
			def name
				if node = @node.css("name").first
					node.text.strip
				end
			end
			
			def description
				if node = @node.css("description").first
					node.text.strip
				end
			end
			
			def bounding_circle
				if look_at = @node.css("LookAt").first
					longitude = look_at.css("longitude").first.text.to_f
					latitude = look_at.css("latitude").first.text.to_f
					range = look_at.css("range").first.text.to_f
					
					center = Location.new(longitude, latitude)
					
					return Circle.new(center, range)
				end
			end
			
			def polygons
				return to_enum(:polygons) unless block_given?
				
				@node.css("Polygon").collect do |polygon_node|
					coordinates_node = polygon_node.css("coordinates").first
					
					text = coordinates_node.text.strip
					coordinates = text.split(/\s+/).collect do |coordinate| 
						Vector.elements(coordinate.split(',').collect(&:to_f).first(2))
					end
					
					yield Polygon.new(coordinates)
				end
			end
		end
	end
end
