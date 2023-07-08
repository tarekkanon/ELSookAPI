from DBConnection import Connection
from Modules.Products.Queries import ProductsQry

def GetAllProducts():
    with Connection.DBHandler() as DBConn:
        result = DBConn.ReadQuery(ProductsQry.QryAllProducts())
    return result

def GetProduct(product_id):
    with Connection.DBHandler() as DBConn:
        product_details = dict()
        product_details = DBConn.ReadQuery(ProductsQry.QryProduct(), product_id)
        product_options = dict()
        product_options = DBConn.ReadQuery(ProductsQry.QryProductOptions(), product_id)
        #product_details['options'] = DBConn.ReadQuery(ProductsQry.QryProductOptions(), product_id)
        if(product_options):
            for index, option in enumerate(product_options):
                product_details[0]['option'] = option
                option[index] =  DBConn.ReadQuery(ProductsQry.QryProductVariants(), { 'ProductId' : product_id, 'ProductOptionId' : int(option['ProductOptionId'])})

    return product_details

def GetAllSellerProducts(seller):
    with Connection.DBHandler() as DBConn:
        result = DBConn.ReadQuery(ProductsQry.QryAllSellerProducts(), seller)
    return result