from DBConnection import Connection
from Modules.Reviews.Queries import ReviewsQry

def GetAllProductReviews(product):
    with Connection.DBHandler() as DBConn:
        result = DBConn.ReadQuery(ReviewsQry.QryGetProductReviews(), product)
    
    return result