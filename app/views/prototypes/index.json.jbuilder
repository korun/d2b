json.array!(@prototypes) do |prototype|
  json.extract! prototype, :id
  json.url prototype_url(prototype, format: :json)
end
