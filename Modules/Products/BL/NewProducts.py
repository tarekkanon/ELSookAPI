from DBConnection import Connection
from Modules.Products.Queries import ProductsQry 

'''
New products Business logic
'''
def AddNewProduct(product):
    
    with Connection.DBHandler() as DBConn:
    
        try:
            # first we take product data only to create it first and have an ID
            product_new_data = product['Product']
            product_id = __CreateNewProduct(DBConn, product_new_data)
            
            # check result success or not 
            if int(product_id) > 0:
                # then we add this ID into the main json payload
                product['ProductId'] = int(product_id)
                
                for option in product['Options']:
                    # add to the option payload the product id before insert
                    option['ProductId'] = product['ProductId']
                    
                    # then we split the variants of the option outside
                    option_variants = option['Variants']
                    
                    # now take the options main data only 
                    del option['Variants']
                        
                    # now add the option and then get its id
                    option_id = CreateNewProductOption(DBConn, option)
                    
                    # check result of option id valid
                    
                    if int(option_id) > 0:
                        # now iterate over the variants to add them
                        for variant in option_variants:
                            # add the product id in each variant
                            variant['ProductId'] = option['ProductId']
                            # add the option id  in each variant
                            variant['ProductOptionId'] = int(option_id)
                            # now add each variant
                            variant_id = CreateNewProductVariant(DBConn, variant)
                            
                # now we insert the tags per product
                for tag in product['ProductTags']:
                    # add the product id to the tag json
                    tag['ProductId'] = int(product_id)
                    
                    # then insert the tag to database
                    CreateNewProductTag(DBConn, tag)
        except:
            DBConn.RollbackTransaction()
            raise
            
        DBConn.CommitTransaction()
        
    return product_id

def AddProductImages(product_images):
    
    with Connection.DBHandler() as DBConn:
        
        try:
            for image in product_images:
                imageId = CreateNewProductImage(DBConn, image)
        except:
            DBConn.RollbackTransaction()
            raise
            
        DBConn.CommitTransaction()
    
    return imageId

'''
//New products Business logic
'''


'''
Insert statments each record
'''
def __CreateNewProduct(con, product_data):
    result = con.InsertUncommittedQuery(ProductsQry.QryNewProduct(), (
        product_data['ProductName'], 
        product_data['ProductDescription'],
        product_data['ProductUnit'],
        product_data['ProductStatus'],
        product_data['SellerId'],
        product_data['SubCategoryId']
    ))
    return result

def CreateNewSingleProduct(product_data):
    with Connection.DBHandler() as DBConn:
        result = DBConn.InsertQuery(ProductsQry.QryNewProduct(), (
            product_data['ProductName'], 
            product_data['ProductDescription'],
            product_data['ProductUnit'],
            product_data['ProductStatus'],
            product_data['SellerId'],
            product_data['SubCategoryId']
    ))
    return result

def CreateNewProductOption(option_data):
    with Connection.DBHandler() as DBConn:
        result = DBConn.InsertQuery(ProductsQry.QryNewProductOption(), (
        option_data['ProductId'],
        option_data['ProductOptionName'],
        option_data['ProductOptionStatus']
    ))
    return result 

def CreateNewProductVariant(variant_data):
    with Connection.DBHandler() as DBConn:
        result = DBConn.InsertQuery(ProductsQry.QryNewProductVariant(), (
        variant_data['ProductId'],
        variant_data['ProductOptionId'],
        variant_data['ProductVariantName'],
        variant_data['ProductVariantPrice'],
        variant_data['ProductVariantUnit']
    ))
    return result 

def CreateNewProductImage(con, images_data):
    result = con.InsertUncommittedQuery(ProductsQry.QryNewProductImage(), (
    images_data['ProductId'],
    images_data['ProductImagePath'],
    images_data['ProductImageType']
    ))
    return result

def CreateNewProductTag(con, tag_data):
    result = con.InsertUncommittedQuery(ProductsQry.QryNewProductTags(), (
    tag_data['ProductId'],
    tag_data['TagId']
    ))
    return result

'''
//Insert statments each record
'''