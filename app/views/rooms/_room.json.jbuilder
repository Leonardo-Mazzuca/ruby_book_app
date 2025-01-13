json.extract! room, :id, :name, :description, :availability, :address, :price, :image, :created_at, :updated_at
json.url room_url(room, format: :json)
