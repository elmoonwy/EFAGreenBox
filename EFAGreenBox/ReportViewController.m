//
//  ReportViewController.m
//  new_green_box
//
//  Created by Yu on 12/12/14.
//  Copyright (c) 2014 Yu. All rights reserved.
//

#import "ReportViewController.h"

@interface ReportViewController ()

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.side_effects=[[NSMutableArray alloc] initWithObjects:@"Insomia",@"Drizzle",@"Vomit",@"Headache",@"Diarrhea",@"leg pain", nil];
    NSString *res=[Patient getMyDrugs:patient_id];
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[JSONHandler StringToData:res] options:NSJSONReadingMutableContainers error:nil];
    if([[dic objectForKey:@"status"] intValue]==200){
        NSMutableArray *array=[[NSMutableArray alloc] init];
        self.table_data=[dic objectForKey:@"result"];
        for(id obj in self.table_data){
            //  NSString *row=[obj objectForKey:@"drug_name"];
            NSString *row=[NSString stringWithFormat:@"%@,%@",[obj objectForKey:@"drug_id"], [obj objectForKey:@"drug_name"]];
            [array addObject:row];
        }
        self.table_data=array;
    }
    [self connectWebSocket];
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
    NSMutableArray *after_split=[str componentsSeparatedByString:@","];
    NSString *drug_id=[after_split objectAtIndex:0];
    self.selected_drug_id=drug_id;
    //NSString *res=[Patient getSingleDrugInfo:drug_id];
    [self refreshPicker:[self side_effects]];
}

- (void)refreshPicker:(NSMutableArray*)answer{
    self._pickerData=answer;
    //replace the picker
    [self.picker removeFromSuperview];
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
    self.picker.delegate = self;
    self.picker.showsSelectionIndicator = YES;
    [self.view addSubview: self.picker];
}

-(int)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self._pickerData.count;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self._pickerData[row];
}
- (IBAction)report_action:(id)sender {
    NSString *res=[self._pickerData objectAtIndex:[self.picker selectedRowInComponent:0]];
//    NSString *request_res=[Patient doReport:patient_id withDrugID:[self selected_drug_id] withSideEffects:res];
//    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[JSONHandler StringToData:request_res] options:NSJSONReadingMutableContainers error:nil];
//    if([[dic objectForKey:@"status"] intValue]==200){
//        UIAlertView *messageAlert = [[UIAlertView alloc]
//                                     initWithTitle:@"Report" message: @"Report success" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [messageAlert show];
//    }
    
    //send websocket messages to my providers
    for(id provider_id in providers_user_ids){
        NSString *msg=[NSString stringWithFormat:@"Patient %@ reported a side effect because of %@.", patient_name, [self._pickerData objectAtIndex:[self.picker selectedRowInComponent:0]]];
        NSArray *keys = [NSArray arrayWithObjects:@"user_id", @"msg", @"type", @"sender_name", nil];
        
        NSArray *objects = [NSArray arrayWithObjects:provider_id, msg, @"report", patient_name, nil];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects
                                                               forKeys:keys];
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
        NSString* msgforsend = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        [self.webSocket send: msgforsend];
    }
            UIAlertView *messageAlert = [[UIAlertView alloc]
                                         initWithTitle:@"Report" message: @"Report success" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [messageAlert show];
}

- (IBAction)back_action:(id)sender {
    [self.webSocket close];
    DrugsListViewController *view=[self.storyboard instantiateViewControllerWithIdentifier:@"DrugsListViewController"];
    [self presentViewController:view animated:YES completion:nil];
}


#pragma mark - SRWebSocket delegate

- (void)connectWebSocket {
    NSString *urlString=[NSString stringWithFormat: [WEBSOCKET_URL stringByAppendingString:@"?user_id=%@"],user_id];
    NSLog(@"this is user_id: %@", user_id);
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
@end
