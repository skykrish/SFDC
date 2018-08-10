public class EPMS_SendInvoice_Invocable{
  @InvocableMethod(label='SendInvoice' description='Send Invoice when Anken Status was Delivered')
  public static void SendInvoice(List<String> Id){
  EPMS_SendInvoiceController SendInvoice=new EPMS_SendInvoiceController(Id); 
    
  }
}