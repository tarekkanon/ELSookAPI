def QryGetAllCustomerOrders():
    return '''
            select * from CustomersOrders where CustomerId = ?;
            '''
            
def QryGetAllSellerOrders():
    return '''
            select * from SellersOrders where SellerId = ?;
            '''

def QryGetSellerOrderLine():
    return '''
            select * from SellersOrders where OrderLineId = ?;
            '''

def QryGetProductDetailsForCart():
    return '''
            select * from CartProductDetails where ProductId = ? and ProductOptionId = ? and ProductVariantId = ?;
            '''

def QryNewOrder():
    return '''
            INSERT INTO [Orders]
                    ([CustomerId]
                    ,[OrderTotal]
                    ,[OrderStatus]
                    ,[OrderDate])
                VALUES
                    (?,?,?,?)
            '''
            
def QryUpdateOrderStatus():
    return '''
            UPDATE [Orders]
                SET [OrderStatus] = ?,
                    [LastUpdateDate] = CURRENT_TIMESTAMP
                WHERE [OrderId] = ?
            '''            
            
def QryNewOrderLine():
    return '''
            INSERT INTO [OrderLines]
                    ([SellerId]
                    ,[OrderId]
                    ,[ProductId]
                    ,[ProductVariantId]
                    ,[ProductOptionId]
                    ,[Quantity]
                    ,[Price])
                VALUES
                    (?,?,?,?,?,?,?)
            '''            

def QryUpdateOrderLineQtyPrice():
    return ''''
            UPDATE [OrderLines]
            SET [Quantity] = ?
                ,[Price] = ?
            WHERE [OrderLineId] = ?
            '''            