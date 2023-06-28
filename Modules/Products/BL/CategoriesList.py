from DBConnection import Connection
from Modules.Products.Queries import CategoriesQry

def GetAllCategoriesActive():
    with Connection.DBHandler() as DBConn:
        result = DBConn.ReadQuery(CategoriesQry.QryGetAllActiveCategories())
    
    return result

