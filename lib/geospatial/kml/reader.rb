# Copyright, 2017, by Samuel G. D. Williams. <http://www.codeotaku.com>
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
require 'geospatial/polygon'

module Geospatial
	module KML
		class Reader
			def self.load_file(path)
				doc = File.open(path) {|file| Nokogiri::XML(file)}
				
				return self.new(doc)
			end
			
			def initialize(doc)
				@doc = doc
			end
			
			attr :doc
			
			def polygons
				@doc.css("Polygon").collect do |polygon_node|
					coordinates_node = polygon_node.css("coordinates").first
					
					text = coordinates_node.text.strip
					coordinates = text.split(/\s+/).collect do |coordinate| 
						Vector.elements(coordinate.split(',').collect(&:to_f).first(2))
					end
					
					Polygon.new(coordinates)
				end
			end
		end
	end
end
