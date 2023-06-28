from DBConnection import Connection
from Modules.Reviews.Queries import ReviewsQry
from datetime import datetime


'''
New review Business logic
'''
def AddNewReview(review_data):
    with Connection.DBHandler() as DBConn:
        try:
            review_data['ReviewDate'] = datetime.now()
            review_data['ReviewStatus'] = 'New'
            review_id = __CreateNewReview(DBConn, review_data)
        except:
            DBConn.RollbackTransaction()
            raise
            
        DBConn.CommitTransaction()
        
    return review_id
'''
//New review Business logic
'''

'''
Insert statments each record
'''
def __CreateNewReview(con, review_data):
    result = con.InsertUncommittedQuery(ReviewsQry.QryNewReview(), (
        review_data['OrderId'], 
        review_data['OrderLineId'],
        review_data['ProductId'],
        review_data['SellerId'],
        review_data['ReviewDate'],
        review_data['ReviewStars'],
        review_data['ReviewComment'],
        review_data['ReviewStatus']
    ))
    return result
'''
/Insert statments each record
'''