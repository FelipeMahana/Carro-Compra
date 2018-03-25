class OrdersController < ApplicationController
	before_action :authenticate_user!

	def empty_cart
		current_user.cart.destroy_all
		redirect_to orders_path, notice: 'El carro a sido eliminado'
	end

	def index
		@orders = current_user.cart
		#@total = @orders.map { |order| order.product.price}.sum()
		@total = @orders.inject(0){ |total, order| total += order.product.price * order.quantity}
	end

	def destroy
		@order = Order.find(params[:id])

		if @order.quantity == 1
			if @order.destroy
				redirect_to orders_path, notice: "carro actualizado"
			else
				redirect_to orders_path, notice: "error al actualizar la pagina"
			end
		elsif @order.quantity > 1
			@order.quantity -= 1
			if @order.save
				redirect_to orders_path, notice: 'Carro actualizado'
			else 
				redirect_to orders_path, notice: "error al actualizar la pagina"
			end	
		end
	end

	def create

		@previus_order = Order.find_by(user_id: current_user.id, product_id: params[:product_id], payed: false)
		if @previus_order.present?
			new_quantity = @previus_order.quantity + 1
			@previus_order.update(quantity: new_quantity)
		else
			@order = Order.new()
			@order.product = Product.find(params[:product_id])
			@order.user = current_user
		

			if @order.save
				redirect_to root_path, notice: 'El producto a sido cargado al carro de compras'
			else
				redirect_to root_path, alert: 'El producto no a sido cargado al carro de compra'
			end
		end	
	end
end
