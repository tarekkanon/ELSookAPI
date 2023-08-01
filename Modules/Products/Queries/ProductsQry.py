
def QryAllProducts():
    return "SELECT * FROM Products WHERE ProductStatus = 1;"

def QryAllSellerProducts():
    return "SELECT * FROM SellerProducts WHERE SellerId = ?;"

def QryProduct():
    return "SELECT * FROM Products WHERE ProductId = ?"

def QryProductOptions():
    return "SELECT * FROM ProductOptions WHERE ProductId = ?"

def QryProductVariants():
    return "SELECT * FROM ProductVariants WHERE ProductId = ? AND ProductOptionId = ?"

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

def QryUpdateProductOption():
    return '''
                UPDATE ProductOptions
                SET ProductOptionName = ?
                    , ProductOptionStatus = ?
                    , LastUpdateDate = CURRENT_TIMESTAMP
                WHERE ProductOptionId = ?;
            '''

def QryUpdateProductVariant():
    return '''
                UPDATE ProductVariants
                SET ProductVariantName = ?
                    , ProductVariantPrice = ?
                    , ProductVariantUnit = ?
                    , LastUpdateDate = CURRENT_TIMESTAMP
                WHERE ProductVariantId = ?;
            '''

def QryUpdateProduct():
    return '''
                UPDATE [Products]
                SET [ProductName] = ?
                    ,[ProductDescription] = ?
                    ,[ProductUnit] = ?
                    ,[ProductStatus] = ?
                    ,[SubCategoryId] = ?
                    ,[LastUpdateDate] = CURRENT_TIMESTAMP
                WHERE ProductId = ?
    '''