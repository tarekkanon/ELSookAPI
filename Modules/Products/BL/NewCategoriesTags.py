from DBConnection import Connection
from Modules.Products.Queries import CategoriesQry

'''
Insert statments each record
'''
def CreateNewCategory(category_data):
    with Connection.DBHandler() as DBConn:
        result = DBConn.InsertQuery(CategoriesQry.QryNewCategory(), (
        category_data['CategoryName'], 
        category_data['CategoryDescription'],
        category_data['CategoryStatus']
    ))
    
    return result

def CreateNewSubCategory(subcategory_data):
    with Connection.DBHandler() as DBConn:
        result = DBConn.InsertQuery(CategoriesQry.QryNewSubCategory(), (
        subcategory_data['CategoryId'], 
        subcategory_data['SubCategoryName'],
        subcategory_data['SubCategoryDescription'],
        subcategory_data['SubCategoryStatus']
    ))
    
    return result

def CreateNewTag(tag_data):
    with Connection.DBHandler() as DBConn:
        result = DBConn.InsertQuery(CategoriesQry.QryNewTag(), (
        tag_data['TagText'], 
        tag_data['TagStatus'],
        tag_data['TagPriority'],
        tag_data['TagAvailability'],
        tag_data['ParentTagId']
    ))
    
    return result
'''
//Insert statments each record
'''


'''
Update statments each record
'''
def UpdateCategory(category_data):
    with Connection.DBHandler() as DBConn:
        result = DBConn.UpdateQuery(CategoriesQry.QryUpdateCategory(), (
        category_data['CategoryName'], 
        category_data['CategoryDescription'],
        category_data['CategoryStatus'],
        category_data['CategoryId']
    ))
    
    return result

def UpdateSubCategory(subcategory_data):
    with Connection.DBHandler() as DBConn:
        result = DBConn.UpdateQuery(CategoriesQry.QryUpdateSubCategory(), (
        subcategory_data['SubCategoryName'], 
        subcategory_data['SubCategoryDescription'],
        subcategory_data['SubCategoryStatus'],
        subcategory_data['SubCategoryId']
    ))
    
    return result

def UpdateTag(tag_data):
    with Connection.DBHandler() as DBConn:
        result = DBConn.UpdateQuery(CategoriesQry.QryUpdateTag(), (
        tag_data['TagText'], 
        tag_data['TagStatus'],
        tag_data['TagPriority'],
        tag_data['TagAvailability'],
        tag_data['ParentTagId'],
        tag_data['TagId']
    ))
    
    return result

'''
//Update statments each record
'''