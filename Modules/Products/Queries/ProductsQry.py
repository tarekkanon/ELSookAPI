
def QryAllProducts():
    return "SELECT * FROM Products WHERE ProductStatus = 1;"

def QryProduct():
    return "SELECT * FROM Products WHERE ProductId = ?"

def QryNewProduct():
    return '''INSERT INTO Products 
                (ProductName, ProductDescription, ProductUnit, ProductStatus, SellerId, SubCategoryId) 
                VALUES (?,?,?,?,?,?)'''
                        
def QryNewProductOption():
    return '''
            INSERT INTO [ProductOptions]
                ([ProductId]
                ,[ProductOptionName]
                ,[ProductOptionStatus]
                )
            VALUES
                (?,?,?)
            '''
        
def QryNewProductVariant():
    return '''
            INSERT INTO [ProductVariants]
                ([ProductId]
                ,[ProductOptionId]
                ,[ProductVariantName]
                ,[ProductVariantPrice]
                ,[ProductVariantUnit])
            VALUES
                (?,?,?,?,?)
        '''
        
def QryNewProductImage():
    return '''
            INSERT INTO [ProductImages]
                ([ProductId]
                ,[ProductImagePath]
                ,[ProductImageType])
            VALUES
                (?,?,?)
        '''
        
def QryNewProductTags():
    return '''
                INSERT INTO [ProductTags]
                    ([ProductId]
                    ,[TagId])
                VALUES
                    (?,?)
            '''