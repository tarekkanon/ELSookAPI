def QryGetProductReviews():
    return '''
            select * from Reviews where ProductId = ?
            '''

def QryNewReview():
    return '''
            INSERT INTO [Reviews]
                    ([OrderId]
                    ,[OrderLineId]
                    ,[ProductId]
                    ,[SellerId]
                    ,[ReviewDate]
                    ,[ReviewStars]
                    ,[ReviewComment]
                    ,[ReviewStatus])
                VALUES
                    (?,?,?,?,?,?,?,?)

            '''
            
def QryUpdateReview():
    return '''
            UPDATE [Reviews]
            SET [ReviewDate] = ?
                ,[ReviewStars] = ?
                ,[ReviewComment] = ?
                ,[ReviewStatus] = ?
            WHERE [ReviewId] = ?
            '''