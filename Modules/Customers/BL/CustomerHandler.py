from DBConnection import Connection
from Modules.Customers.Queries import CustomerQry
import re

def CreateNewCustomer(customer_data):
    with Connection.DBHandler() as DBConn:
        result = DBConn.InsertQuery(CustomerQry.QryNewCustomer(), (
        customer_data['CustomerName'],
        customer_data['CustomerAddress'],
        customer_data['CustomerEmail'],
        customer_data['CustomerPassword'],
        customer_data['CustomerPaymentChannels']
    ))
    
    return result 

def LoginCustomer(customer_login):
    
    # we need to check that there is supplied email address
    if not re.fullmatch(r'[^@]+@[^@]+\.[^@]+', customer_login['SellerEmail']):
        return
    
    with Connection.DBHandler() as DBConn:
        result = DBConn.ReadQuery(CustomerQry.QryLoginCustomer(), (
        customer_login['CustomerEmail'],
        customer_login['CustomerPassword']
    ))
    
    return result

def UpdateCustomer(customer_data):
    with Connection.DBHandler() as DBConn:
        result = DBConn.UpdateQuery(CustomerQry.QryUpdateCustomer(), (
        customer_data['CustomerAddress'],
        customer_data['CustomerPaymentChannels'],
        customer_data['CustomerId']
    ))
    
    return result 

def UpdateCustomerPassword(customer_data):
    with Connection.DBHandler() as DBConn:
        result = DBConn.UpdateQuery(CustomerQry.QryUpdateCustomerPassword(), (
        customer_data['CustomerPassword'],
        customer_data['CustomerId']
    ))
    
    return result 