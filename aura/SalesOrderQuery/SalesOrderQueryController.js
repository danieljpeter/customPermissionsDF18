({
    doInit : function(cmp, event, helper) {
        var action = cmp.get("c.getSalesOrders");

        action.setCallback(this, function(response) {
            var retObj = response.getReturnValue();
            //console.log(retObj);

            cmp.set("v.salesOrdersUser", retObj.salesOrdersUser);
            cmp.set("v.salesOrdersSystem", retObj.salesOrdersSystem);
        });
        $A.enqueueAction(action);
    },
    saveUser : function(cmp, event, helper) {
        var action = cmp.get("c.saveSalesOrdersUser");
        action.setParams({salesOrders: cmp.get("v.salesOrdersUser")});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                alert("Success.");
            } else if (state === "ERROR") {
                var errors = response.getError();
                var errorMsg = JSON.stringify(errors);
                alert("Error: " + errorMsg);
            }
        });
        $A.enqueueAction(action);
    },
    saveSystem : function(cmp, event, helper) {
        var action = cmp.get("c.saveSalesOrdersSystem");
        action.setParams({salesOrders: cmp.get("v.salesOrdersSystem")});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                alert("Success.");
            } else if (state === "ERROR") {
                var errors = response.getError();
                var errorMsg = JSON.stringify(errors);
                alert("Error: " + errorMsg);
            }
        });
        $A.enqueueAction(action);
    }
})