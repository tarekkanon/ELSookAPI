def QryNewShipment():
    return '''
            INSERT INTO [Shipments]
                    ([OrderLineId]
                    ,[ShipmentTrackingNumber]
                    ,[ShippingCompany])
                VALUES
                    (?,CONVERT(VARCHAR(255), NEXT VALUE FOR ShipmentTrackerNumberSeq),?)
            '''
            
def QryNewShipmentTracker():
    return '''
            INSERT INTO [dbo].[ShipmentTracker]
                    ([ShipmentId]
                    ,[ShipmentTrackerDate]
                    ,[ShipmentTrackerStatus])
                VALUES
                    (?,?,?)
            '''
            
def QryGetShipments():
    return '''
            SELECT * FROM GetOrderLinesShipmentsTracker
            '''