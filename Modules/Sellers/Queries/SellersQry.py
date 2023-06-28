def QryLoginSeller():
    return "SELECT * FROM [Sellers] WHERE SellerEmail = ? AND SellerPassword = ?;"

def QryGetAllSellers():
    return "SELECT * FROM [Sellers];"

def QryNewSeller():
    return '''
            INSERT INTO [Sellers]
                ([SellerName]
                ,[SellerAddress]
                ,[SellerEmail]
                ,[SellerPassword]
                ,[SellerPaymentChannels])
            VALUES
                (?,?,?,?,?)
            '''
            
def QryUpdateSeller():
    return '''
                UPDATE [Sellers]
                SET [SellerAddress] = ?
                    ,[SellerPaymentChannels] = ?
                WHERE SellerId = ?
            '''
            
def QryUpdateSellerPassword():
    return '''
                UPDATE [Sellers]
                SET [SellerPassword] = ?
                WHERE SellerId = ?
            '''