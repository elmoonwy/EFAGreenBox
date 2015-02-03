//
//  PrescriptionDetailsViewController.m
//  new_green_box
//
//  Created by Yu on 1/16/15.
//  Copyright (c) 2015 Yu. All rights reserved.
//

#import "PrescriptionDetailsViewController.h"

@interface PrescriptionDetailsViewController ()

@end

@implementation PrescriptionDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableArray *array=[self loadTableData:patient_id withPrescriptionID:self.prescription_id];
    self.table_data=[[NSMutableArray alloc] init];
    for(id obj in array){
        NSString *row=[[NSString alloc] initWithFormat:@"Drug:%@", [obj objectForKey:@"drug_name"]];
        [self.table_data addObject:row];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)loadTableData:(NSString*)patient_id withPrescriptionID:(NSString*)prescription_id{
    NSString *res=[Patient getDrugsInPrescription:patient_id withPrescriptionId:prescription_id];
    NSDictionary *drug_dic=[NSJSONSerialization JSONObjectWithData:[JSONHandler StringToData:res] options:NSJSONReadingMutableContainers error:nil];
    if([[drug_dic objectForKey:@"status"] intValue]==200){
        return [drug_dic objectForKey:@"result"];
    }
    else{
        return nil;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back_btn_action:(id)sender {
    PrescriptionsListViewController *view=[self.storyboard instantiateViewControllerWithIdentifier:@"PrescriptionsListViewController"];
    [self presentViewController:view animated:YES completion:nil];
    NSLog(@"wo teme xianghuiqu!");
}

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
}
@end
