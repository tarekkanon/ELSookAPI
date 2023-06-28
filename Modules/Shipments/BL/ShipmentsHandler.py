from DBConnection import Connection
from datetime import datetime
from Modules.Shipments.Queries import ShipmentQry


'''
New Shipments Business logic
'''
def AddNewOrderShipment(shipment):
    with Connection.DBHandler() as DBConn:
        try:
            shipment_id = __CreateNewShipment(DBConn, shipment['shipment'])
            
            shipment['shipment_tracker']['ShipmentId'] = shipment_id
            shipment['shipment_tracker']['ShipmentTrackerDate'] = datetime.now()
            shipment['shipment_tracker']['ShipmentTrackerStatus'] = 'New'
            
            if shipment_id > 0:
                shipment_tracker_id = __CreateNewShipmentTracker(DBConn, shipment['shipment_tracker'])
                
            if not shipment_tracker_id:
                raise
            
        except:
            DBConn.RollbackTransaction()
            raise
            
        DBConn.CommitTransaction()
        
    return shipment_id


def AddNewTrackerStatus(shipment):
    with Connection.DBHandler() as DBConn:
        try:
            shipment['shipment_tracker']['ShipmentTrackerDate'] = datetime.now()
            shipment_tracker_id = __CreateNewShipmentTracker(DBConn, shipment['shipment_tracker'])

            if not shipment_tracker_id:
                raise
            
        except:
            DBConn.RollbackTransaction()
            raise
            
        DBConn.CommitTransaction()
        
    return shipment_tracker_id

'''
//New Shipments Business logic
'''







'''
Insert statments each record
'''
def __CreateNewShipment(con, shipment_data):
    result = con.InsertUncommittedQuery(ShipmentQry.QryNewShipment(), (
        shipment_data['OrderLineId'], 
        shipment_data['ShippingCompany']
    ))
    return result

def __CreateNewShipmentTracker(con, shipment_tracker_data):
    result = con.InsertUncommittedQuery(ShipmentQry.QryNewShipmentTracker(), (
        shipment_tracker_data['ShipmentId'], 
        shipment_tracker_data['ShipmentTrackerDate'],
        shipment_tracker_data['ShipmentTrackerStatus']
    ))
    return result
'''
/Insert statments each record
'''