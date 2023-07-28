from DBConnection import Connection
from Modules.Products.Queries import ProductsQry

def UpdateProductOption(product_option):
    with Connection.DBHandler() as DBConn:
        result = DBConn.UpdateQuery(ProductsQry.QryUpdateProductOption(), (
        product_option['ProductOptionName'],
        product_option['ProductOptionStatus'],
        product_option['ProductOptionId']
    ))
    return result 

def UpdateProductVariant(product_variant):
    with Connection.DBHandler() as DBConn:
        result = DBConn.UpdateQuery(ProductsQry.QryUpdateProductVariant(), (
        product_variant['ProductVariantName'],
        product_variant['ProductVariantPrice'],
        product_variant['ProductVariantUnit'],
        product_variant['ProductVariantId']
    ))
    return result 

def UpdateProduct(product):
    with Connection.DBHandler() as DBConn:
        result = DBConn.UpdateQuery(ProductsQry.QryUpdateProduct(), (
        product['ProductName'],
        product['ProductDescription'],
        product['ProductUnit'],
        product['ProductStatus'],
        product['ProductId']
    ))
    return result 