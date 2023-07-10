from DBConnection import Connection
from Modules.Products.Queries import ProductsQry

def GetAllProducts():
    with Connection.DBHandler() as DBConn:
        result = DBConn.ReadQuery(ProductsQry.QryAllProducts())
    return result

'''
to get single product details with all it's options and all variants of the options
'''
def GetProduct(product_id):
    with Connection.DBHandler() as DBConn:

        # get product first
        product_details = DBConn.ReadQuery(ProductsQry.QryProduct(), product_id)
        
        # then get all product options
        product_options = DBConn.ReadQuery(ProductsQry.QryProductOptions(), product_id)
        
        # if there is options then get their variants
        if(product_options):
            # create empty list to hold all options
            options = []

            # loop on the product options to get each option variant and then add to the options list
            for index, option in enumerate(product_options):
                variants =  DBConn.ReadQuery(ProductsQry.QryProductVariants(), ( product_id , int(option['ProductOptionId']) ))
                option['Variants'] = variants
                options.append(option)

            # then add all the options with their variants to the product details list
            product_details[0]['Options'] = options

    return product_details

def GetAllSellerProducts(seller):
    with Connection.DBHandler() as DBConn:
        result = DBConn.ReadQuery(ProductsQry.QryAllSellerProducts(), seller)
    return result