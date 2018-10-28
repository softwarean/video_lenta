require 'test_helper'

class CameraJsonSourceTest < ActionController::TestCase
  setup do
    @broadcasting = create :broadcasting
  end

  test "should download json from localhost" do
    url = "/data/#{@broadcasting.slug}/index.json"

    uri = "http://localhost#{url}"
    data = "test_data"
    stub_request(:get, uri).to_return(status: 200, body: data)

    assert_equal data, CameraJsonSource.download_json(url)
  end

  test "should get camera json" do
    url = CameraJsonSource.index_file_url(@broadcasting)

    data = {"test" => "data"}
    stub_request(:any, /.*#{url}/).to_return(status: 200, body: data.to_json)

    json = CameraJsonSource.get_json(@broadcasting)

    assert_equal data, json
  end

  test "should get date json" do
    date = DateTime.now
    url = CameraJsonSource.date_file_url(@broadcasting, date)

    data = {"test" => "data"}
    stub_request(:any, /.*#{url}/).to_return(status: 200, body: data.to_json)

    json = CameraJsonSource.get_json_for_date(@broadcasting, date)

    assert_equal data, json
  end
end
