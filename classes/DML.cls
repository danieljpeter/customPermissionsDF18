public without sharing class DML {

    public List<sObject> sObjs  {get; set;}
    public String objName       {get; set;}
    public List<String> fieldsToCheck  {get; set;}
    private Map <String, Schema.SObjectType> schemaMap;

    public Boolean isSystemMode {get; set;}

    public DML() {
        isSystemMode = false;
    }

    public void doUpdate() {

        if (Permissions.isSystemMode()) {
            isSystemMode = true;
        }

        if (isSystemMode) {
            update sObjs;
        } else {
            schemaMap = Schema.getGlobalDescribe();
            Map <String, Schema.SObjectField> fieldMap = schemaMap.get(objName).getDescribe().fields.getMap();

            if (!sObjs.isEmpty()) {
                List<String> noAccessFields = new List<String>();
                for (String f : fieldsToCheck) {
                    //if it's not an Id or a calc field and we don't have access to update it
                    if (!fieldMap.get(f).getDescribe().isUpdateable()) {
                        noAccessFields.add(f);
                    }
                }
                if (!noAccessFields.isEmpty()) {
                    String sFields = String.join(noAccessFields, ', ');
                    throw new NoAccessException('No Access to these fields: ' + sFields);
                } else {
                    update sObjs;
                }
            }
        }
    }


    public class NoAccessException extends Exception {}



}