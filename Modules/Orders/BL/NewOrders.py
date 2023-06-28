from DBConnection import Connection
from Modules.Orders.Queries import OrdersQry
from datetime import datetime

'''
Business logic for adding new order from cart
'''
def AddNewOrder(cart):
    
    with Connection.DBHandler() as DBConn:
        
        # for calculating totla order amount
        total_price = 0
        
        # will be used to validate the total items inserted
        count_products = 0
        count_products_inserted = 0
        
        try:
            # loop on items to get insertable details for the table of order lines 
            for product in cart['Products']:
                product_details = GetCartProductDetails(DBConn, product)
                product['Price'] = int(product_details[0]['ProductVariantPrice'])
                product['SellerId'] = int(product_details[0]['SellerId'])
                
                # increment on the total order amount according to the quantity  
                total_price = total_price + (product['Quantity'] * product['Price'])
                
                # increment the count of items inside the cart
                count_products =+ 1
            
            # add the total order amount to the order object to be inserted 
            cart['Order']['OrderTotal'] = total_price
            
            # get current datetime of the creation of the order
            cart['Order']['OrderDate'] = datetime.now()
            
            # status of the order is new
            cart['Order']['OrderStatus'] = 'New'
            
            # now insert into the orders table and get orderId to the order object 
            cart['Order']['OrderId'] = int(CreateNewOrder(DBConn, cart['Order']))
            
            # check order object is inserted in table
            if cart['Order']['OrderId'] > 0:
                
                # now loop on the items to insert into the order lines
                for product in cart['Products']:
                    product['OrderId'] = cart['Order']['OrderId']
                    inserted = CreateNewOrderLine(DBConn, product)
                    
                    # check if item inserted and increment the count of the total items inserted
                    if inserted:
                        count_products_inserted =+ 1
            
        except:
            DBConn.RollbackTransaction()
            raise
        
        # check if all items are inserted then commit transaction
        if count_products == count_products_inserted:
            DBConn.CommitTransaction()
        else:
            # in case of any faliure just rollback
            DBConn.RollbackTransaction()
        
            
    print(cart)
    return cart['Order']['OrderId']
'''
//
'''

'''
Insert statements
'''
def GetCartProductDetails(con, product):
    result = con.ReadQuery(OrdersQry.QryGetProductDetailsForCart(), (
        product['ProductId'],
        product['ProductOptionId'],
        product['ProductVariantId']  
    ))
    return result


def CreateNewOrder(con, order_data):
    result = con.InsertUncommittedQuery(OrdersQry.QryNewOrder(), (
        order_data['CustomerId'],
        order_data['OrderTotal'],
        order_data['OrderStatus'],
        order_data['OrderDate']
    ))
    return result 

def CreateNewOrderLine(con, order_line_data):
    result = con.InsertUncommittedQuery(OrdersQry.QryNewOrderLine(), (
        order_line_data['SellerId'],
        order_line_data['OrderId'],
        order_line_data['ProductId'],
        order_line_data['ProductVariantId'],
        order_line_data['ProductOptionId'],
        order_line_data['Quantity'],
        order_line_data['Price']
    ))
    return result 

'''
//Insert statements
'''