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

def GetAllSellerOrderLine(seller_order_line):
    with Connection.DBHandler() as DBConn:
        result = DBConn.ReadQuery(OrdersQry.QryGetSellerOrderLine(), (
            seller_order_line['OrderLineId']
        ))
    return result 


def UpdateOrderStatus(order_data):
    with Connection.DBHandler() as DBConn:
        result = DBConn.UpdateQuery(OrdersQry.QryUpdateOrderStatus(), (
            order_data['OrderStatus'],
            order_data['OrderId']
        ))
    return result 

def UpdateOrderStatusConfirmed(order_data):
    with Connection.DBHandler() as DBConn:
        order_data['OrderStatus'] = 'Confirmed'
        result = DBConn.UpdateQuery(OrdersQry.QryUpdateOrderStatus(), (
            order_data['OrderStatus'],
            order_data['OrderId']
        ))
    return result 

def UpdateOrderStatusRequestShipping(order_data):
    with Connection.DBHandler() as DBConn:
        order_data['OrderStatus'] = 'Shipping Requested'
        result = DBConn.UpdateQuery(OrdersQry.QryUpdateOrderStatus(), (
            order_data['OrderStatus'],
            order_data['OrderId']
        ))
    return result 

def UpdateOrderStatusPickedUp(order_data):
    with Connection.DBHandler() as DBConn:
        order_data['OrderStatus'] = 'Picked up'
        result = DBConn.UpdateQuery(OrdersQry.QryUpdateOrderStatus(), (
            order_data['OrderStatus'],
            order_data['OrderId']
        ))
    return result 

def UpdateOrderStatusOutDelivery(order_data):
    with Connection.DBHandler() as DBConn:
        order_data['OrderStatus'] = 'Out for delivery'
        result = DBConn.UpdateQuery(OrdersQry.QryUpdateOrderStatus(), (
            order_data['OrderStatus'],
            order_data['OrderId']
        ))
    return result 

def UpdateOrderStatusDelivered(order_data):
    with Connection.DBHandler() as DBConn:
        order_data['OrderStatus'] = 'Delivered'
        result = DBConn.UpdateQuery(OrdersQry.QryUpdateOrderStatus(), (
            order_data['OrderStatus'],
            order_data['OrderId']
        ))
    return result 

def UpdateOrderStatusCancelled(order_data):
    with Connection.DBHandler() as DBConn:
        order_data['OrderStatus'] = 'Cancelled'
        result = DBConn.UpdateQuery(OrdersQry.QryUpdateOrderStatus(), (
            order_data['OrderStatus'],
            order_data['OrderId']
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