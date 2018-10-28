json.localities do
  json.array! @localities do |locality|
    json.name locality
  end
end
