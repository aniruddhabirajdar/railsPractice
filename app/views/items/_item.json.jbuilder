json.extract! item, :id, :order_id, :name, :price, :quantity, :created_at, :updated_at
json.url item_url(item, format: :json)
