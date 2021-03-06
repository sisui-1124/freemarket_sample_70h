class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :products_name, null:false
      t.text :descreption, null:false
      t.integer :price, null:false
      t.string :brand
      t.string :product_condition, null:false
      t.string :shipment_fee, null:false
      t.integer :prefecture_id, null:false
      t.string :shipping_period, null:false
      t.references :user, index: true, foreign_key:true
      t.integer :category_id, foreign_key:true
      # t.integer :seller_id, null:false
      t.integer :buyer_id
      t.integer :sale_status, null: false, default: 0

      t.timestamps
    end
  end
end
