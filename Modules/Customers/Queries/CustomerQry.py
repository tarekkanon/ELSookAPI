def QryLoginCustomer():
    return '''
            SELECT * FROM [Customers] WHERE [CustomerEmail] = ? AND [CustomerPassword] = ?;
            '''

def QryNewCustomer():
    return '''
            INSERT INTO [Customers]
                    ([CustomerName]
                    ,[CustomerAddress]
                    ,[CustomerEmail]
                    ,[CustomerPassword]
                    ,[CustomerPaymentChannels])
                VALUES
                    (?,?,?,?,?)
            '''
            
def QryUpdateCustomer():
    return '''
                UPDATE [Customers]
                SET [CustomerAddress] = ?
                    ,[CustomerPaymentChannels] = ?
                WHERE CustomerId = ?
            '''
            
def QryUpdateCustomerPassword():
    return '''
                UPDATE [Customers]
                SET [CustomerPassword] = ?
                WHERE CustomerId = ?
            '''