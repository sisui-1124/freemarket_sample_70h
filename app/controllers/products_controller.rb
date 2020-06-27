class ProductsController < ApplicationController

  def buy
    unless @product.soldout
      card = Card.where(user_id: current_user.id)
      if card.exists?
        @card     = Card.find_by(user_id: current_user.id)
        Payjp.api_key = ENV['PAYJP_PRIVATE_KEY']
        customer = Payjp::Customer.retrieve(@card.customer_id)
        @default_card_information = Payjp::Customer.retrieve(@card.customer_id).cards.data[0]
      end
    else
      redirect_to product_path(@product)
    end
  end
  
  # 商品出品後のデータを反映させる Nonaka
  # コメントを反映させる Nonaka
  def show
    @product = Product.find(params[:id])
    @comment = Comment.new
    @comments = @product.comments.includes(:user)
  end

  def index
    @parents = Category.all.order("id ASC").limit(13)
    @products = Product.all
  end
  
  def new
    @product = Product.new
    @product.pictures.build()
  end

  def create
    # binding.pry
    @product = Product.new(product_params)
      respond_to do |format|
        if @product.save
            params[:product_pictures][:picture].each do |picture|
              @product.pictures.create(picture: picture, product_id: @product.id)
            end
          format.html{redirect_to root_path}
        else
          @product.pictures.build
          format.html{render action: 'new'}
        end
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

  def edit
    @product = Product.find(params[:id])
  end

  private

  def product_params
    params.require(:product).permit(:products_name, :descreption, :price, :brand, :product_condition, :shipment_fee, :shipping_place, :shipping_period, :category_id, :sale_status, pictures_attributes: [:picture]).merge(user_id: current_user.id)
  end

  def pay
    @products = products.find(params[:id])
    Payjp.api_key = ENV['']
    charge = Payjp::Charge.create(
    amount: 1000,
    # amount: @products.price, <=最終的にこちらに差し替え
    card: params['payjp-token'],
    currency: 'jpy'
    )
  end
end
