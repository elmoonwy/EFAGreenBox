//
//  DrugsListViewController.m
//  new_green_box
//
//  Created by Yu on 12/8/14.
//  Copyright (c) 2014 Yu. All rights reserved.
//

#import "DrugsListViewController.h"

@interface DrugsListViewController ()

@end

@implementation DrugsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *res=[Patient getMyDrugs:patient_id];
    NSLog(@"the result is: %@", res);
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[JSONHandler StringToData:res] options:NSJSONReadingMutableContainers error:nil];
    if([[dic objectForKey:@"status"] intValue]==200){
        NSMutableArray *array=[[NSMutableArray alloc] init];
        self.table_data=[dic objectForKey:@"result"];
        for(id obj in self.table_data){
          //  NSString *row=[obj objectForKey:@"drug_name"];
            NSString *row=[NSString stringWithFormat:@"%@,%@",[obj objectForKey:@"drug_name"], [obj objectForKey:@"prescription_instance_id"]];
            //Set the alarm to eat drugs
            if([obj objectForKey:@"time_for_day"]!=NULL){
                NSArray *times=[[obj objectForKey:@"time_of_day"] componentsSeparatedByString:@","];
                for(id time in times){
                    [self scheduleAlarmForDate:[Patient getDate:time] withDrugName:[obj objectForKey:@"drug_name"]];
                }
            }
            [array addObject:row];
        }
        self.table_data=array;
        [self connectWebSocket];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.table_data count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = [self.table_data objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *str=cell.textLabel.text;
    
    NSArray *after_split=[str componentsSeparatedByString:@","];
    NSString *res=[Patient eatDrug:[after_split objectAtIndex:1] withPatientID:patient_id];
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[JSONHandler StringToData:res] options:NSJSONReadingMutableContainers error:nil];
    
    NSString *alert_msg=@"";
    if([[dic objectForKey:@"status"] intValue]==200){
        alert_msg=[dic objectForKey:@"msg"];
        //send websocket to notify provider
        [self tellProviderTakenDrug:[dic objectForKey:@"result"] withDrugName: [after_split objectAtIndex:0]];
    }
    if([dic objectForKey:@"flag"]!=NULL){
        [Patient finishTakingDrug:[after_split objectAtIndex:1]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setUserInteractionEnabled:NO];
        [cell setAlpha:0.5];
    }
    
    // Display Alert Message
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:@"You have taken it!" message: alert_msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [messageAlert show];
}

- (IBAction)report_action:(id)sender {
    [self.webSocket close];
    ReportViewController *view=[self.storyboard instantiateViewControllerWithIdentifier:@"ReportViewController"];
    [self presentViewController:view animated:YES completion:nil];
}

- (IBAction)back_action:(id)sender {
    [self.webSocket close];
    PatientLoginViewController *view=[self.storyboard instantiateViewControllerWithIdentifier:@"PatientLoginViewController"];
    [self presentViewController:view animated:YES completion:nil];
}

//--------Taking picture for Ex code
- (IBAction)scan_qrcode_action:(id)sender {
    NSLog(@"Scanning..");
    self.result_text.text = @"Scanning..";
    
    ZBarReaderViewController *codeReader = [ZBarReaderViewController new];
    codeReader.readerDelegate=self;
    codeReader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = codeReader.scanner;
    [scanner setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];
    
    [self presentViewController:codeReader animated:YES completion:nil];
}

- (IBAction)rx_btn_action:(id)sender {
    PrescriptionsListViewController *view=[self.storyboard instantiateViewControllerWithIdentifier:@"PrescriptionsListViewController"];
    [self presentViewController:view animated:YES completion:nil];
}

- (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    //  get the decode results
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // just grab the first barcode
        break;
    // showing the result on textview
    self.result_text.text = symbol.data;
    NSString *prescription_id=[self getPrescriptionId:self.result_text.text];
    //right after scanning the qrcode, the order is generated
    [Patient generateNewOrder:@"1" withRxStr: prescription_id];
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Order sent" message: @"Your order has been sent!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [messageAlert show];
    
    self.resultImageView.image = [info objectForKey: UIImagePickerControllerOriginalImage];
    // dismiss the controller
    [reader dismissViewControllerAnimated:YES completion:nil];
}
//-----------END

- (void)scheduleAlarmForDate:(NSDate*)theDate withDrugName:(NSString *)drug_name
{
    UIApplication* app = [UIApplication sharedApplication];
    NSArray* oldNotifications = [app scheduledLocalNotifications];
    
    // Clear out the old notification before scheduling a new one.
    if ([oldNotifications count] > 0)
        [app cancelAllLocalNotifications];
    
    // Create a new notification.
    UILocalNotification* alarm = [[UILocalNotification alloc] init];
    if (alarm)
    {
        alarm.fireDate = theDate;
        alarm.timeZone = [NSTimeZone defaultTimeZone];
        alarm.repeatInterval = 5;
        alarm.soundName = @"alarmsound.caf";
        alarm.alertBody = [@"Time to take" stringByAppendingString:drug_name];
        NSLog(@"set rington alarm to eat drugs:%@", alarm.alertBody);
        
        [app scheduleLocalNotification:alarm];
    }
}

#pragma mark - SRWebSocket delegate

- (void)connectWebSocket {
    NSString *urlString=[NSString stringWithFormat: [WEBSOCKET_URL stringByAppendingString:@"?user_id=%@"],user_id];
    SRWebSocket *newWebSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:urlString]];
    self.webSocket=newWebSocket;
    newWebSocket=nil;
    self.webSocket.delegate=self;
    [self.webSocket open];
}

- (void)webSocketDidOpen:(SRWebSocket *)newWebSocket {
    self.webSocket = newWebSocket;
    NSArray *keys = [NSArray arrayWithObjects:@"key1", @"key2", nil];
    NSArray *objects = [NSArray arrayWithObjects:@"value1", @"value2", nil];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects
                                                           forKeys:keys];
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    NSString* msgforsend = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    
    //  [self.webSocket send: msgforsend];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    // [self connectWebSocket];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    // [self connectWebSocket];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"message for ws:%@", message);
    NSData *data=[message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:@"message from your provider" message: [dic objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [messageAlert show];
}

-(NSString*)getPrescriptionId:(NSString*)result_str{
    NSArray *after_split=[result_str componentsSeparatedByString:@"="];
    NSString *prescription_id=[after_split objectAtIndex:[after_split count]-1];
    return prescription_id;
}

-(void)tellProviderTakenDrug:(NSString*)user_id_of_provider withDrugName:(NSString*)drug_name{
    NSString *msg=[NSString stringWithFormat:@"Patient %@ just took the drug %@.", patient_name, drug_name];
    NSArray *keys = [NSArray arrayWithObjects:@"user_id", @"msg", @"type", @"sender_name", nil];
        
    NSArray *objects = [NSArray arrayWithObjects:user_id_of_provider, msg, @"eat_drug", patient_name, nil];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects
                                                               forKeys:keys];
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    NSString* msgforsend = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    [self.webSocket send: msgforsend];
}
@end
