public without sharing class Query {


    public List<String> qFields {get; set;}
    public String objName       {get; set;}
    public String whereClause   {get; set;}

    private String queryString {get; set;}
    private Map <String, Schema.SObjectType> schemaMap;

    public Boolean isSystemMode {get; set;}

    public Query() {
        isSystemMode = false;
    }

    public List<sObject> doQuery() {

        if (Permissions.isSystemMode()) {
            isSystemMode = true;
        }

        List<String> fieldsToQuery = qFields;

        if (!isSystemMode) {
            schemaMap = Schema.getGlobalDescribe();
            Map <String, Schema.SObjectField> fieldMap = schemaMap.get(objName).getDescribe().fields.getMap();

            //scrub the list of fields and remove any which they can't access
            List<String> qFieldsAccessible = new List<String>();

            for (String f: qFields) {
                if (fieldMap.get(f).getDescribe().isAccessible()) {
                    qFieldsAccessible.add(f);
                }
            }
            fieldsToQuery = qFieldsAccessible;
        }

        //turn the set of fields into a comma separated list
        String sFields = String.join(fieldsToQuery, ',');

        //set the WHERE clause
        String wClause = '';
        if (whereClause != null) {
            wClause = ' ' + whereClause;
        }

        queryString = 'SELECT ' + sFields + ' FROM ' + objName + wClause;

        if (isSystemMode) {
            QueryNoSharing qns = new QueryNoSharing(queryString);
            return qns.doQuery();
        } else {
            QueryWithSharing qws = new QueryWithSharing(queryString);
            return qws.doQuery();
        }
    }



    private without sharing class QueryNoSharing {
        private String sQuery;

        public QueryNoSharing(String q) {
            sQuery = q;
        }

        public List<sObject> doQuery() {
            return Database.Query(sQuery);
        }
    }

    private with sharing class QueryWithSharing {
        private String sQuery;

        public QueryWithSharing(String q) {
            sQuery = q;
        }

        public List<sObject> doQuery() {
            return Database.Query(sQuery);
        }
    }




}