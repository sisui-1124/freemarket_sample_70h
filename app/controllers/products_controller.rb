class ProductsController < ApplicationController

  def buy
  end
  
  # 商品出品後のデータを反映させる Nonaka
  def show
    @product = Product.find(params[:id])
  end

  def index
    @parents = Category.all.order("id ASC").limit(13)
    @products = Product.all
  end
  
  def new
    @product = Product.new
    @product.pictures.build
  end

  def create
    # binding.pry
    if params[:pictures].present?
      @product = Product.new(product_params)
      if @product.save
        params[:pictures][:picture].each do |picture|
          @product.pictures.create(picture: picture)
        end
          redirect_to root_path
      else
        redirect_to new_product_path
      end
    else
      redirect_to new_product_path
    end
  end
  
  # destroy アクション nonaka
  def destroy
    product = Product.find(params[:id])
    if product.destroy
      redirect_to users_index_path, notice: "商品の削除が完了しました"
    else
      redirect_to users_index_path, alert: "商品の削除ができませんでした"
    end
  end

  private

  def product_params
    params.require(:product).permit(:products_name, :descreption, :price, :brand, :product_condition, :shipment_fee, :shipping_place, :shipping_period, :category_id, :sale_status, pictures_attributes: [:picture]).merge(user_id: current_user.id)
  end
end
