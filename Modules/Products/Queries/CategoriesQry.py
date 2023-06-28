def QryGetAllActiveCategories():
    return "SELECT * FROM GetCategoriesDetails"

def QryGetAllActiveTagsByPriority():
    return "SELECT * FROM [TagsTreeView] WHERE TagAvailability = 1 ORDER BY TagPriority;"

def QryNewCategory():
    return '''
            INSERT INTO [Categories]
                    ([CategoryName]
                    ,[CategoryDescription]
                    ,[CategoryStatus])
                VALUES
                    (?,?,?)
            '''
            
def QryNewSubCategory():
    return '''
            INSERT INTO [SubCategories]
                    ([CategoryId]
                    ,[SubCategoryName]
                    ,[SubCategoryDescription]
                    ,[SubCategoryStatus])
                VALUES
                    (?,?,?,?)
            '''
            
def QryNewTag():
    return '''
            INSERT INTO [Tags]
                    ([TagText]
                    ,[TagStatus]
                    ,[TagPriority]
                    ,[TagAvailability]
                    ,[ParentTagId])
                VALUES
                    (?,?,?,?,?)
            '''
            
def QryUpdateCategory():
    return '''
                UPDATE [Categories]
                SET [CategoryName] = ?
                    ,[CategoryDescription] = ?
                    ,[CategoryStatus] = ?
                WHERE CategoryId = ?
            '''
            
def QryUpdateSubCategory():
    return '''
            UPDATE [SubCategories]
            SET 
                [SubCategoryName] = ?
                ,[SubCategoryDescription] = ?
                ,[SubCategoryStatus] = ?
            WHERE SubCategoryId = ?
            '''
            
            
def QryUpdateTag():
    return '''
                UPDATE [Tags]
                SET [TagText] = ?
                    ,[TagStatus] = ?
                    ,[TagPriority] = ?
                    ,[TagAvailability] = ?
                    ,[ParentTagId] = ?
                WHERE TagId = ?
            '''