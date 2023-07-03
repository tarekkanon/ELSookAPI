from DBConnection import Connection
from Modules.Sellers.Queries import SellersQry
import re

def CreateNewSeller(seller_data):
    with Connection.DBHandler() as DBConn:
        result = DBConn.InsertQuery(SellersQry.QryNewSeller(), (
        seller_data['SellerName'],
        seller_data['SellerAddress'],
        seller_data['SellerEmail'],
        seller_data['SellerPassword'],
        seller_data['SellerPaymentChannels']
    ))
    
    return result

def LoginSeller(seller_login):
    
    # we need to check that there is supplied email address
    if not re.fullmatch(r'[^@]+@[^@]+\.[^@]+', seller_login['SellerEmail']):
        return
    
    with Connection.DBHandler() as DBConn:
        result = DBConn.ReadQuery(SellersQry.QryLoginSeller(), (
        seller_login['SellerEmail'],
        seller_login['SellerPassword']
    ))
    
    return result

def LoginSellerSession(seller_login):
    
    with Connection.DBHandler() as DBConn:
        result = DBConn.ReadQuery(SellersQry.QryLoginSellerSession(), (
        seller_login['SellerId']
    ))
    
    return result

def UpdateSellerDetails(seller_data):
    with Connection.DBHandler() as DBConn:
        result = DBConn.UpdateQuery(SellersQry.QryUpdateSeller(), (
        seller_data['SellerAddress'],
        seller_data['SellerPaymentChannels'],
        seller_data['SellerId'],
    ))
    
    return result

def UpdateSellerPassword(seller_data):
    with Connection.DBHandler() as DBConn:
        result = DBConn.UpdateQuery(SellersQry.QryUpdateSellerPassword(), (
        seller_data['SellerPassword'],
        seller_data['SellerId'],
    ))
    
    return result