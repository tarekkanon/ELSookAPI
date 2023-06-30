import pyodbc

class DBHandler():
    
    def __init__(self):
        pass
    
    def __enter__(self):
        
        self.conn = pyodbc.connect(
                        Driver="{SQL Server}",
                        Server = "Kanonz\SQLEXPRESS",
                        Database = "ELSookBase",
                        User = "sa",
                        Password = "pioneer")
        
        self.conn.autocommit = False
        
        self.cursor = self.conn.cursor()
        
        return self
    
    def __exit__(self, exception_type, exception_val, trace):
        self.cursor.close()
        self.conn.close()
        
    def __to_dict(self, row):
        return dict(zip([t[0] for t in row.cursor_description], row))

    def ReadQuery(self, query, params=[]):
        self.cursor.execute(query, params) 
        results = [self.__to_dict(row) for row in self.cursor.fetchall()]
        return results
    
    def InsertQuery(self, query, params=[]):
        self.cursor.execute(query, params)
        id = self.cursor.execute("SELECT @@IDENTITY AS ID;").fetchone()[0]
        self.cursor.commit()
        return id

    def InsertUncommittedQuery(self, query, params=[]):
        self.cursor.execute(query, params)
        id = self.cursor.execute("SELECT @@IDENTITY AS ID;").fetchone()[0]
        return id

    def UpdateQuery(self, query, params=[]):
        rows_count = self.cursor.execute(query,params)
        self.cursor.commit()
        return rows_count.rowcount
    
    def CommitTransaction(self):
        self.conn.commit()
        
    def RollbackTransaction(self):
        self.conn.rollback()
    
    
