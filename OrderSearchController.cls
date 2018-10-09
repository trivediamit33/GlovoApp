/*
@Author:Amit Trivedi
@Description: Controller to search order by customer number. To be used in community.
*/

public  class OrderSearchController{
    public Order order{get;set;}
    public List<Order> orderList {get;set;}
    public string searchTerm{get;set;}
    private integer totalRecs = 0;
    private integer OffsetSize = 0;
    private integer LimitSize= 10;
    
    public OrderSearchController(){
        
         orderList = new List<Order>();
         
    }
    
    
    public Void searchOrders(){
    
        
        if(orderList != null && !orderList.isEmpty()){
            orderList.clear();
        }
        
        orderList = [SELECT Id,Name,
                            AccountId,
                            Account.Name,
                            Account.AccountNumber,
                            OrderNumber 
                     From Order 
                     WHERE Account.AccountNumber=:searchTerm
                     LIMIT :LimitSize OFFSET :OffsetSize];  
           
    }
    
    public void clear(){
        searchTerm = '';
        if(orderList != null && !orderList.isEmpty()){
            orderList.clear();
        }
    }
    
    public void FirstPage()
    {
        OffsetSize = 0;
        searchOrders();
    }
    
    public void previous()
    {
        OffsetSize = (OffsetSize-LimitSize);
        searchOrders();
    }

    public void next()
    {
        OffsetSize = OffsetSize + LimitSize;
        searchOrders();
    }
    
    public void LastPage()
    {
        OffsetSize = totalrecs - math.mod(totalRecs,LimitSize);
        searchOrders();
    }
    
    public boolean getprev()
    {
        
        if(OffsetSize == 0){
            
            return true;
        }
        else {
        
            return false;
        }
    }
    
    public boolean getnxt()
    {
        if((OffsetSize + LimitSize) > totalRecs){
        
            return true;
        }
        else {
        
            return false;
        }
    }    
}