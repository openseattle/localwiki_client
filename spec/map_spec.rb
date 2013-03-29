$LOAD_PATH.unshift File.expand_path("../../lib/localwiki", __FILE__)
require 'resource'
require 'json'

describe 'Localwiki' do

  context '::Map' do

    context 'instance with single points coordinates' do

      before(:all) do
        json = %@{
                "geom":
                  {"geometries":
                    [{"coordinates":
                      [-122.370919, 47.570641], "type": "Point"}
                    ],
                    "type": "GeometryCollection"
                  },
                  "id": 390,
                  "length": 0.0,
                  "lines": null,
                  "page": "/api/page/Luna_Park_Cafe",
                  "points": {"coordinates": [[-122.370919, 47.570641]], "type": "MultiPoint"},
                  "polys": null,
                  "resource_uri": "/api/map/Luna_Park_Cafe"
                }@
        @map = Localwiki::Map.new(JSON.parse(json))
      end

      it "#single_point? is true where points contains only one point" do
        @map.should be_single_point
      end

      it "#line? is not true where lines attribute is not null" do
        @map.should_not be_line
      end

      it "#poly? is not true where polys attribute is not null" do
        @map.should_not be_poly
      end

      it "#lat contains lattitude if #single_point?" do
        @map.lat.should eq -122.370919
      end

      it "#long contains longitude if #single_point?" do
        @map.long.should eq 47.570641
      end

    end

    context 'instance with multiple points coordinates' do

      before(:all) do
        json = %@{
                  "geom": {
                    "geometries": [
                      {"coordinates": [-122.315414, 47.664818], "type": "Point"},
                      {"coordinates": [-122.380344, 47.561239], "type": "Point"}
                    ],
                    "type": "GeometryCollection"
                  },
                  "id": 5,
                  "length": 0.0,
                  "lines": null,
                  "page": "/api/page/Chaco_Canyon_Cafe",
                  "points": {
                    "coordinates": [
                      [-122.315414, 47.664818],
                      [-122.380344, 47.561239]
                    ],
                    "type": "MultiPoint"
                  },
                  "polys": null,
                  "resource_uri": "/api/map/Chaco_Canyon_Cafe"
                }@
        @map = Localwiki::Map.new(JSON.parse(json))
      end

      it "#single_point? is false where points contains more than one point" do
        @map.should_not be_single_point
      end

      it "#lat is nil where multiple points coordinates exist" do
        @map.lat.should be_nil
      end

      it "#long is nil where multiple points coordinates exist" do
        @map.long.should be_nil
      end

    end

    context 'instance with polys coordinates' do

      before(:all) do
        json = %@{
                  "geom":
                    {"geometries":
                      [{"coordinates":
                        [[
                          [-122.38683, 47.596621], [-122.400563, 47.585159], [-122.419789, 47.575548], [-122.400906, 47.554468], [-122.397473, 47.53755], [-122.40022, 47.529437], [-122.39507, 47.524801], [-122.399361, 47.51715], [-122.321599, 47.516918], [-122.320569, 47.531871], [-122.329838, 47.537087], [-122.345288, 47.55748], [-122.348721, 47.566978], [-122.357991, 47.573348], [-122.363141, 47.584175], [-122.371209, 47.583567], [-122.38683, 47.596621]]], "type": "Polygon"}], "type": "GeometryCollection"}, "id": 389, "length": 0.299969686560957, "lines": null, "page": "/api/page/West_Seattle", "points": null, "polys": {"coordinates": [[[[-122.38683, 47.596621], [-122.400563, 47.585159], [-122.419789, 47.575548], [-122.400906, 47.554468], [-122.397473, 47.53755], [-122.40022, 47.529437], [-122.39507, 47.524801], [-122.399361, 47.51715], [-122.321599, 47.516918], [-122.320569, 47.531871], [-122.329838, 47.537087], [-122.345288, 47.55748], [-122.348721, 47.566978], [-122.357991, 47.573348], [-122.363141, 47.584175], [-122.371209, 47.583567], [-122.38683, 47.596621]
                        ]]
                      ],
                      "type": "MultiPolygon"
                    },
                    "resource_uri": "/api/map/West_Seattle"
                  }@
        @map = Localwiki::Map.new(JSON.parse(json))
      end

      it "#single_point? is not true where points attribute is null" do
        @map.should_not be_single_point
      end

      it "#lat is nil where no points coordinates exist" do
        @map.lat.should be_nil
      end

      it "#long is nil where no points coordinates exist" do
        @map.long.should be_nil
      end

      it "#line? is not true where lines attribute is null" do
        @map.should_not be_line
      end

      it "#poly? is true where polys attribute is not null" do
        @map.should be_poly
      end
      
    end
  end
end
