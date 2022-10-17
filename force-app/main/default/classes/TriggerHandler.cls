public virtual class TriggerHandler {
    System.TriggerOperation context;
    public TriggerHandler(){
        context = Trigger.operationType;
    }

    public TriggerHandler(System.TriggerOperation context){
        this.context = context;
    }
    public void run(){
        String sobjectName = getList()?.getSObjectType()?.getDescribe()?.getName();
        if(!TriggerHandlerConfigurationUtils.canRun(sobjectName, context?.name())){
            return;
        }
        if(context == System.TriggerOperation.BEFORE_INSERT){
            beforeInsert();
        }
        else if(context == System.TriggerOperation.BEFORE_UPDATE){
            beforeUpdate();
        }
        else if(context == System.TriggerOperation.BEFORE_DELETE){
            beforeDelete();
        }
        else if(context == System.TriggerOperation.AFTER_INSERT){
            afterInsert();
        }
        else if(context == System.TriggerOperation.AFTER_UPDATE){
            afterUpdate();
        }
        else if(context == System.TriggerOperation.AFTER_DELETE){
            afterDelete();
        }
        else if(context == System.TriggerOperation.AFTER_UNDELETE){
            afterUndelete();
        }
        else{
            String message = 'Invalid Trigger Context: '+context?.name();
            throw new TriggerHandlerException(message);
        }
    }

    private List<SObject> getList(){
        return (Trigger.isDelete) ? (Trigger.old) : Trigger.new;
    }
    public virtual void beforeInsert(){}
    public virtual void beforeUpdate(){}
    public virtual void beforeDelete(){}
    public virtual void afterInsert(){}
    public virtual void afterUpdate(){}
    public virtual void afterDelete(){}
    public virtual void afterUndelete(){}
    public class TriggerHandlerException extends Exception{}
}