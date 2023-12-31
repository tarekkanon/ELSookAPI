import os
import string
from mimetypes import MimeTypes 
from flask import Flask,jsonify, request
from flask_jwt_extended import JWTManager, jwt_required, create_access_token, get_jwt_identity
from random import choices

from Modules.Products.BL import ProductsList
from Modules.Products.BL import CategoriesList
from Modules.Products.BL import NewCategoriesTags 
from Modules.Products.BL import NewProducts
from Modules.Products.BL import UpdateProduct
from Modules.Sellers.BL import SellerHandler
from Modules.Customers.BL import CustomerHandler
from Modules.Orders.BL import OrdersHandler
from Modules.Orders.BL import NewOrders
from Modules.Reviews.BL import NewReview
from Modules.Reviews.BL import ReviewsList
from Modules.Reviews.BL import UpdateReview
from Modules.Shipments.BL import ShipmentsHandler

app = Flask(__name__)
jwt = JWTManager(app)

app.config['JWT_SECRET_KEY'] = 'passphrase'


    
    
'''
All products API's
'''
@app.route("/products", methods=["GET"])
def GetAllProductsAPI():
  """Get all products."""
  products = ProductsList.GetAllProducts()
  return jsonify(products), 200

@app.route("/products/<product_id>", methods=["GET"])
def get_product(product_id):
  """Get a product by ID."""
  product = ProductsList.GetProduct(product_id)
  return jsonify(product), 200

@app.route("/products/seller", methods=["GET"])
@jwt_required()
def get_seller_products():
  """Get sellers products list."""
  seller_data = request.json
  products = ProductsList.GetAllSellerProducts(seller_data['SellerId'])
  return jsonify(products), 200

@app.route("/products/new", methods=["POST"])
@jwt_required()
def create_product():
  """Create a new product."""
  #print(get_jwt_identity())
  product_data = request.json
  #productId = NewProducts.AddNewProduct(product_data)
  productId = NewProducts.CreateNewSingleProduct(product_data)
  return jsonify({"message": "Product created", "ProductId" : productId}), 200

@app.route("/products/images", methods=["POST"])
@jwt_required()
def add_product_images():
  """Add all product images."""
  product_images = request.json
  imageId = NewProducts.AddProductImages(product_images)
  return jsonify({"message": "Images added", "LastImageId" : imageId}), 200

@app.route("/products/update_option", methods=["PUT"])
@jwt_required()
def update_product_option():
  """Update product option details."""
  product_option = request.json
  rowcount = UpdateProduct.UpdateProductOption(product_option)
  return jsonify({"message": "Product option updated", "rowcount" : rowcount}), 200

@app.route("/products/update_variant", methods=["PUT"])
@jwt_required()
def update_product_variant():
  """Update product variant details."""
  product_variant= request.json
  rowcount = UpdateProduct.UpdateProductVariant(product_variant)
  return jsonify({"message": "Product variant updated", "rowcount" : rowcount}), 200

@app.route("/products/new_option", methods=["POST"])
@jwt_required()
def new_product_option():
  """New product option details."""
  product_option = request.json
  product_option_id = NewProducts.CreateNewProductOption(product_option)
  return jsonify({"message": "product option created", "ProductOptionId" : product_option_id}), 200

@app.route("/products/new_variant", methods=["POST"])
@jwt_required()
def new_product_variant():
  """New product variant details."""
  product_variant= request.json
  product_variant_id = NewProducts.CreateNewProductVariant(product_variant)
  return jsonify({"message": "product variant created", "ProductVariantId" : product_variant_id}), 200

@app.route("/products/update", methods=["PUT"])
@jwt_required()
def update_product():
  """Update product details."""
  product= request.json
  rowcount = UpdateProduct.UpdateProduct(product)
  return jsonify({"message": "Product updated", "rowcount" : rowcount}), 200


@app.route("/products/upload_images", methods=["POST"])
@jwt_required()
def upload_images():
  """Uploads multiple image files to the server.

  Args:
    images: The image files.

  Returns:
    The URLs of the uploaded image files.
  """

  # Check if the image files are present.
  if not request.files:
    return jsonify({"error": "No image files were provided."}), 400

  image_values = [file for file in request.files.values()]
  
  # Generate a random string of 10 characters depending on list of files.
  image_names_appended = [("".join(choices(string.ascii_lowercase, k=10)) + MimeTypes().guess_extension(type=img.mimetype)) for img in image_values]
  
  # Save the image files.
  for image_name, image in zip(image_names_appended, image_values):
    with open(os.path.join("uploads", image_name), "wb") as f:
      f.write(image.read())

  images_result = []
  
  for res_name , path_name in zip(request.files, image_names_appended):
    res = {"name" : res_name, "path" : "/uploads/{}".format(path_name)}
    images_result.append(res)

  # Return the URLs of the uploaded image files.
  return jsonify(images_result), 201




'''
All Categories API
'''
@app.route("/categories", methods=["GET"])
def GetAllActiveCategoriesAPI():
  """Get all active categories & sub cateogies details."""
  categories = CategoriesList.GetAllCategoriesActive()
  return jsonify(categories), 200

@app.route("/categories", methods=["POST"])
def create_category():
  """Create a new category."""
  data = request.json
  categoryId = NewCategoriesTags.CreateNewCategory(data)
  return jsonify({"message": "category created", "categoryId" : categoryId}), 200

@app.route("/subcategories", methods=["POST"])
def create_sub_category():
  """Create a new sub category."""
  data = request.json
  subCategoryId = NewCategoriesTags.CreateNewSubCategory(data)
  return jsonify({"message": "sub category created", "subcategoryId" : subCategoryId}), 200

@app.route("/tag", methods=["POST"])
def create_tag():
  """Create a new tag."""
  data = request.json
  tagId = NewCategoriesTags.CreateNewTag(data)
  return jsonify({"message": "tag created", "tagId" : tagId}), 200

@app.route("/categories", methods=["PUT"])
def update_category():
  """update category."""
  data = request.json
  rowcount = NewCategoriesTags.UpdateCategory(data)
  return jsonify({"message": "category updated", "rowcount" : rowcount}), 200

@app.route("/subcategories", methods=["PUT"])
def update_sub_category():
  """update sub category."""
  data = request.json
  rowcount = NewCategoriesTags.UpdateSubCategory(data)
  return jsonify({"message": "sub category updated", "rowcount" : rowcount}), 200

@app.route("/tag", methods=["PUT"])
def update_tag():
  """update tag."""
  data = request.json
  rowcount = NewCategoriesTags.UpdateTag(data)
  return jsonify({"message": "tag updated", "rowcount" : rowcount}), 200


'''
All Sellers API
'''
@app.route("/sellers", methods=["POST"])
def create_seller():
  """Create a new seller account."""
  seller_data = request.json
  sellerId = SellerHandler.CreateNewSeller(seller_data)
  return jsonify({"message": "Seller account created", "SellerId" : sellerId}), 200

@app.route("/sellers/login", methods=["POST"])
def login_seller():
  """Login seller by email and password."""
  seller_data = request.json
  seller = SellerHandler.LoginSeller(seller_data)
  
  if seller:
    token = create_access_token(identity = seller[0]["SellerEmail"])
    seller[0]["token"] = token
    return jsonify(seller), 200 
  else:
    return jsonify({"message": "invalid email or password" }), 404
  
@app.route("/sellers/login_session", methods=["POST"])
def login_seller_session():
  """Login seller by id for session."""
  seller_data = request.json
  seller = SellerHandler.LoginSellerSession(seller_data)
  
  if seller:
    token = create_access_token(identity = seller[0]["SellerEmail"])
    seller[0]["token"] = token
    return jsonify(seller), 200 
  else:
    return jsonify({"message": "invalid email or password" }), 404
  
@app.route("/sellers/update", methods=["PUT"])
@jwt_required()
def update_seller():
  """Update sellers details."""
  seller_data = request.json
  row_count = SellerHandler.UpdateSellerDetails(seller_data)
  return jsonify({"message": "Seller account updated", "rows" : row_count}), 200


@app.route("/sellers/update_password", methods=["PUT"])
@jwt_required()
def update_seller_password():
  """Update sellers password."""
  seller_data = request.json
  row_count = SellerHandler.UpdateSellerPassword(seller_data)
  return jsonify({"message": "Seller password updated", "rows" : row_count}), 200





'''
All customers API
'''
@app.route("/customers", methods=["POST"])
def create_customers():
  """Create a new customer account."""
  customers_data = request.json
  customerId = CustomerHandler.CreateNewCustomer(customers_data)
  return jsonify({"message": "customer account created", "customerId" : customerId}), 200

@app.route("/customers/login", methods=["POST"])
def login_customers():
  """Login customer by email and password."""
  customers_data = request.json
  customer = CustomerHandler.LoginCustomer(customers_data)
  
  if customer:
    return jsonify(customer), 200 
  else:
    return jsonify({"message": "invalid email or password" }), 404
  
@app.route("/customers/update", methods=["PUT"])
@jwt_required()
def update_customers():
  """Update customers details."""
  customers_data = request.json
  row_count = CustomerHandler.UpdateCustomer(customers_data)
  return jsonify({"message": "customer account updated", "rows" : row_count}), 200

@app.route("/customers/update_password", methods=["PUT"])
@jwt_required()
def update_customers_password():
  """Update customers password."""
  customers_data = request.json
  row_count = CustomerHandler.UpdateCustomerPassword(customers_data)
  return jsonify({"message": "customer password updated", "rows" : row_count}), 200




'''
All Orders API
'''

@app.route("/orders", methods=["GET"])
@jwt_required()
def GetAllCustomerOrSellerOrders():
  """Get all customer or seller orders."""
  request_data = request.json
  
  if request_data['type'] == 'customer':  
    orders = OrdersHandler.GetAllCustomerOrders(request_data)
  else:
    orders = OrdersHandler.GetAllSellerOrders(request_data)
  
  return jsonify(orders), 200

@app.route("/orders/order_line", methods=["GET"])
@jwt_required()
def GetSellerOrderLineDetails():
  """Get the details of the order line for seller."""
  request_data = request.json
    
  orderLine = OrdersHandler.GetAllSellerOrderLine(request_data)
  
  return jsonify(orderLine), 200


@app.route("/orders/update", methods=["PUT"])
@jwt_required()
def UpdateOrderStatus():
  """Update order status."""
  request_data = request.json
  
  row_count = OrdersHandler.UpdateOrderStatus(request_data)
  
  return jsonify({"message": "order status updated", "rows" : row_count}), 200

@app.route("/orders/update/confirm", methods=["PUT"])
@jwt_required()
def UpdateOrderConfirm():
  """Update order status to confirmed."""
  request_data = request.json
  
  row_count = OrdersHandler.UpdateOrderStatusConfirmed(request_data)
  
  return jsonify({"message": "order status updated", "rows" : row_count}), 200

@app.route("/orders/update/cancel", methods=["PUT"])
@jwt_required()
def UpdateOrderCancelled():
  """Update order status to cancelled."""
  request_data = request.json
  
  row_count = OrdersHandler.UpdateOrderStatusCancelled(request_data)
  
  return jsonify({"message": "order status updated", "rows" : row_count}), 200

@app.route("/orderline/update", methods=["PUT"])
@jwt_required()
def UpdateOrderLineQtyPrice():
  """Update order line quantity and price."""
  request_data = request.json
  
  row_count = OrdersHandler.UpdateOrderLineQtyPrice(request_data)
  
  return jsonify({"message": "order line qty updated", "rows" : row_count}), 200

@app.route("/orders/new", methods=["POST"])
@jwt_required()
def create_new_order():
  """Create a order."""
  order_data = request.json
  orderId = NewOrders.AddNewOrder(order_data)
  return jsonify({"message": "order created", "SellerId" : orderId}), 200
'''
//All Orders API
'''





'''
All Reviews API
'''
@app.route("/reviews", methods=["GET"])
def get_product_reviews():
  """get all product reviews."""
  product_id = request.json
  reviews = ReviewsList.GetAllProductReviews(product_id)
  return jsonify(reviews), 200 
  #

@app.route("/reviews/new", methods=["POST"])
@jwt_required()
def create_review():
  """create a new review."""
  review_data = request.json
  reviewId = NewReview.AddNewReview(review_data)
  
  return jsonify({"message": "review created", "ReviewId" : reviewId}), 200
  
@app.route("/reviews/update", methods=["PUT"])
@jwt_required()
def update_review():
  """Update review details."""
  review_data = request.json
  row_count = UpdateReview.ModifyReview(review_data)
  return jsonify({"message": "review updated", "rows" : row_count}), 200

'''
//All Reviews API
'''




'''
All Shipments API
'''
@app.route("/shipments/new", methods=["POST"])
def create_shipment():
  """create a new shipment."""
  shipment_data = request.json
  shipmentId = ShipmentsHandler.AddNewOrderShipment(shipment_data)
  
  return jsonify({"message": "shipment created", "ShipmentId" : shipmentId}), 200

@app.route("/shipments/tracker/new_status", methods=["POST"])
def create_shipment_tracker():
  """create a new shipment tracker status."""
  shipment_data = request.json
  shipmentTrackerId = ShipmentsHandler.AddNewTrackerStatus(shipment_data)
  
  return jsonify({"message": "shipment tracker added", "ShipmentTrackerId" : shipmentTrackerId}), 200

'''
//All Shipments API
'''




if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8523 ,debug=True)