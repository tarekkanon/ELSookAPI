from DBConnection import Connection
from Modules.Products.Queries import ProductsQry
from Modules.Products.Queries import CategoriesQry

def GetAllProducts():
    with Connection.DBHandler() as DBConn:
        result = DBConn.ReadQuery(ProductsQry.QryAllProducts())
    return result

'''
to get single product details with all it's options and all variants of the options
'''
def GetProduct(product_id):
    with Connection.DBHandler() as DBConn:
        # define a result holder
        result = {}
        
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
        
        # add to holder the details of the product
        result['product'] = product_details

        # get category details to be used in case of update from frontend
        result['categories'] = DBConn.ReadQuery(CategoriesQry.QryGetAllActiveCategories())

    return result

def GetAllSellerProducts(seller):
    with Connection.DBHandler() as DBConn:
        
        # define a result holder
        result = {}
        
        # get category details to be used in case of update from frontend
        result['categories'] = DBConn.ReadQuery(CategoriesQry.QryGetAllActiveCategories())

        # get all seller products
        result['products'] = DBConn.ReadQuery(ProductsQry.QryAllSellerProducts(), seller)
        
    return result