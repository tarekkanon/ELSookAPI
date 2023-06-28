from DBConnection import Connection
from Modules.Orders.Queries import OrdersQry

def GetAllCustomerOrders(customer_data):
    with Connection.DBHandler() as DBConn:
        result = DBConn.ReadQuery(OrdersQry.QryGetAllCustomerOrders(), (
            customer_data['CustomerId']
        ))
    return result 

def GetAllSellerOrders(seller_data):
    with Connection.DBHandler() as DBConn:
        result = DBConn.ReadQuery(OrdersQry.QryGetAllSellerOrders(), (
            seller_data['SellerId']
        ))
    return result 


def UpdateOrderStatus(order_data):
    with Connection.DBHandler() as DBConn:
        result = DBConn.UpdateQuery(OrdersQry.QryUpdateOrderStatus(), (
            order_data['OrderId'],
            order_data['OrderStatus']
        ))
    return result 

def UpdateOrderLineQtyPrice(order_data):
    with Connection.DBHandler() as DBConn:
        result = DBConn.UpdateQuery(OrdersQry.QryUpdateOrderLineQtyPrice(), (
            order_data['OrderLineId'],
            order_data['Quantity'],
            order_data['Price']
        ))
    return result 