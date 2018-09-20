public with sharing class SalesOrderController {

    @AuraEnabled
    public static Map<String, Object> getSalesOrders() {
        Map<String, Object> retObj = new Map<String, Object>();

        //query in user mode
        Query q = new Query();
        q.objName = 'Sales_Order__c';
        q.qFields = new List<String> {'Id', 'Name', 'Magic_Word__c', 'Quantity__c'};
        q.isSystemMode = false;
        retObj.put('salesOrdersUser', q.doQuery());

        //query in system mode
        q.isSystemMode = true;
        retObj.put('salesOrdersSystem', q.doQuery());

        return retObj;
    }




    @AuraEnabled
    public static void saveSalesOrdersUser(List<sObject> salesOrders) {
        try {
            //update in user mode
            DML d = new DML();
            d.objName = 'Sales_Order__c';
            d.fieldsToCheck = new List<String>{'Magic_Word__c'};
            d.sObjs = salesOrders;
            d.isSystemMode = false;
            d.doUpdate();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    @AuraEnabled
    public static void saveSalesOrdersSystem(List<sObject> salesOrders) {
        try {
            //update in user mode
            DML d = new DML();
            d.objName = 'Sales_Order__c';
            d.sObjs = salesOrders;
            d.isSystemMode = true;
            d.doUpdate();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


}