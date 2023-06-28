from DBConnection import Connection
from Modules.Reviews.Queries import ReviewsQry
from datetime import datetime

'''
Modify review Business logic
'''
def ModifyReview(review_data):
    with Connection.DBHandler() as DBConn:
        try:
            review_data['ReviewDate'] = datetime.now()
            review_data['ReviewStatus'] = 'Update'
            rowcount = __UpdateReview(DBConn, review_data)
        except:
            DBConn.RollbackTransaction()
            raise
            
        DBConn.CommitTransaction()
        
    return rowcount
'''
//Modify review Business logic
'''

'''
Update statments each record
'''
def __UpdateReview(con, review_data):
    result = con.UpdateQuery(ReviewsQry.QryUpdateReview(), (
        review_data['ReviewDate'],
        review_data['ReviewStars'],
        review_data['ReviewComment'],
        review_data['ReviewStatus'],
        review_data['ReviewId'],
    ))
    return result
'''
//Update statments each record
'''