/*
@Author:Amit Trivedi
@Description: To be expose for customer to track order and customer information. It will be used by third party api.
*/
@RestResource(urlMapping='/glovoordersinfo/*')
global class OrderAPIController{

    @HttpGet
    global static ResponseWrapper getOrders() {
    
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        ResponseWrapper response = new ResponseWrapper();
        
        String customerNumber = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        
        if(doSearch(customerNumber)) {
            searchOrders(req, res, response);
            return response;
        }
        else{
            response.status = 'Error';
            response.message = 'Parameter is Incorrect';
            return response;
        }       
    }
    
    private static boolean doSearch(String customerNumber) {
        if(customerNumber == 'glovoordersinfo') {
            return true;
        }
        return false;
    }
    
    private static void searchOrders(RestRequest req, RestResponse res, ResponseWrapper response) {

        String searchTerm = req.params.get('customerNumber');
        
        if(searchTerm == null || searchTerm == '') {
            response.status = 'Error';
            response.message = 'Please provide Customer Number.';
        }
        else {
               
                List<Order> orders = [SELECT Id,Name,
                                             AccountId,
                                             Account.Name,
                                             Account.AccountNumber,
                                             OrderNumber 
                                     From Order 
                                     WHERE Account.AccountNumber=:searchTerm];
       
                
                if(orders != null && orders.size() > 0) {
                response.orderList = orders ;
                response.status = 'Success';
                response.message = orders.size() + ' Orders were found that matched your Customer Number.';
            }
            else {
                response.status = 'Error';
                response.message = 'No Orders where found based on that Customer Number, please search again.';
            }
        }
    }
    global class ResponseWrapper {
        
        global String status {get;set;} 
        global List<Order> orderList{get;set;}
        global String message {get;set;} 
        
        //constructor
        global ResponseWrapper() {
            //default all values
            this.status = 'success';
            this.orderList = new List<Order>();
            this.message = '';
        }
    }
}