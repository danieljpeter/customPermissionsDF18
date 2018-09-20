public without sharing class Permissions {

    private static Map<String, ExecutionContext> executionMap = new Map<String, ExecutionContext>();
    private static Boolean systemMode = false;

    public static Boolean isSystemMode() {
        return systemMode;
    }

    public static Map<String, ExecutionContext> getExecutionMap() {
        return executionMap;
    }

    public static void startAction(String actionName) {
        executionMap.put(actionName, new ExecutionContext(true, FeatureManagement.checkPermission(actionName)));
        updateSystemMode();
    }

    public static void endAction(String actionName) {
        executionMap.put(actionName, new ExecutionContext(false, FeatureManagement.checkPermission(actionName)));
        updateSystemMode();
    }


    private static void updateSystemMode() {
        //loop through the executionMap and see if there is at least 1 execution context we are in that we have access too
        Boolean newSysMode = false;
        for (String actionName : executionMap.keySet()) {
            ExecutionContext ec = executionMap.get(actionName);
            if (ec.isExecuting && ec.hasAccess) {
                newSysMode = true;
                break;
            }
        }
        systemMode = newSysMode;
    }

    //inner class to hold our data elements
    public class ExecutionContext {
        public Boolean isExecuting {get; set;}
        public Boolean hasAccess {get; set;}
        public ExecutionContext(Boolean executing, Boolean access) {
            isExecuting = executing;
            hasAccess = access;
        }
    }

}