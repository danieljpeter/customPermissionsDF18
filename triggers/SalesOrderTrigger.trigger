trigger SalesOrderTrigger on Sales_Order__c (before insert, before update) {


    Permissions.startAction('Update_Inventory');
        Integer totalInventoryChange = 0;
        for (Sales_Order__c so : Trigger.new) {

            Integer oldValue = 0;
            if (Trigger.isUpdate) {
                oldValue = (Trigger.oldMap.get(so.Id).Quantity__c).intValue();
            }

            if (oldValue == null) {
                oldValue = 0;
            }

            Integer newValue = (so.Quantity__c).intValue();
            if (newValue == null) {
                newValue = 0;
            }

            Integer inventoryChange = (oldValue - newValue);
            totalInventoryChange += inventoryChange;
        }

        if (totalInventoryChange != 0) {
            Inventory__c inv = [SELECT Id, Quantity__c FROM Inventory__c LIMIT 1][0];
            Integer invQuant = (inv.Quantity__c).intValue();
            inv.Quantity__c = (invQuant + totalInventoryChange);

            //update in user mode
            DML d = new DML();
            d.objName = 'Inventory__c';
            d.fieldsToCheck = new List<String>{'Quantity__c'};
            d.sObjs = new List<sObject>{inv};
            d.isSystemMode = false;
            d.doUpdate();
        }
    Permissions.endAction('Update_Inventory');


}