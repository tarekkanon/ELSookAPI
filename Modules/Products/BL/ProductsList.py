from DBConnection import Connection
from Modules.Products.Queries import ProductsQry

def GetAllProducts():
    with Connection.DBHandler() as DBConn:
        result = DBConn.ReadQuery(ProductsQry.QryAllProducts())
    return result

def GetProduct(product_id):
    with Connection.DBHandler() as DBConn:
        result = DBConn.ReadQuery(ProductsQry.QryProduct(), product_id)
    return result

def GetAllSellerProducts(seller):
    with Connection.DBHandler() as DBConn:
        result = DBConn.ReadQuery(ProductsQry.QryAllSellerProducts(), seller)
    return result