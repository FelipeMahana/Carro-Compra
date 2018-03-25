class ProductsController < ApplicationController
  def index
  	if params[:buscar].present?
  		consulta = params[:buscar].capitalize
         @products = Product.where('name like ?', "%#{consulta}%")
     else
         @products = Product.all
     end
     respond_to do |f|
     	f.html
     	f.js
     end
  end
end
