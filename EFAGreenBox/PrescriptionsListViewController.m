//
//  PrescriptionsListViewController.m
//  new_green_box
//
//  Created by Yu on 1/16/15.
//  Copyright (c) 2015 Yu. All rights reserved.
//

#import "PrescriptionsListViewController.h"

@interface PrescriptionsListViewController ()

@end

@implementation PrescriptionsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableArray *array=[self loadTableData:patient_id];
    self.table_data=[[NSMutableArray alloc] init];
    for(id obj in array){
        NSString *row=[[NSString alloc] initWithFormat:@"Prescription id:%@", [obj objectForKey:@"prescription_id"]];
        [self.table_data addObject:row];
    }
    [self.tableView reloadData];
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
-(NSMutableArray *)loadTableData:(NSString *)patient_id{
    NSString *res=[Patient getAllMyPrescriptions:patient_id];
    NSDictionary *rx_dic=[NSJSONSerialization JSONObjectWithData:[JSONHandler StringToData:res] options:NSJSONReadingMutableContainers error:nil];
    if([[rx_dic objectForKey:@"status"] intValue]==200){
        return [rx_dic objectForKey:@"result"];
    }
    else{
        return nil;
    }
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
    
    //add button for each row
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0.0f, 0.0f, 150.0f, 25.0f);
    
    [button setTitle:@"Details"
            forState:UIControlStateNormal];
    
    [button addTarget:self
               action:@selector(performExpand:)
     forControlEvents:UIControlEventTouchUpInside];
    
    cell.accessoryView = button;
    return cell;
}

- (void) performExpand:(id)paramSender{
    paramSender=(UITableViewCell*)paramSender;
    UITableViewCell *ownerCell = [paramSender superview];
    
    if (ownerCell != nil){
        NSIndexPath *ownerCellIndexPath =
        [self.tableView indexPathForCell:ownerCell];
        
        NSLog(@"Accessory in index path is tapped. Index path = %@",
              [ownerCell text]);
        NSArray *after_split=[[ownerCell text] componentsSeparatedByString:@":"];
        NSString *rx_id=[after_split objectAtIndex:1];
        //jump to the Rx details
        PrescriptionDetailsViewController *view=[self.storyboard instantiateViewControllerWithIdentifier:@"PrescriptionDetailsViewController"];
        view.prescription_id=rx_id;
        [self presentViewController:view animated:YES completion:nil];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *str=cell.textLabel.text;
    //construct the url for the QRcode
    NSArray *after_split=[str componentsSeparatedByString:@":"];
    NSString *rx_id=[after_split objectAtIndex:1];
    NSString *url=[[NSString alloc] initWithFormat:@"%@pharmacists/show_prescription_detail_by_prescriptionId?id=%@", QRCODE_URL, rx_id];
    self.selected_rx_id=rx_id;
    
    UIImage *image = [self quickResponseImageForString:url withDimension:182];
    
    //set the image
    [self.imageView setImage: image];
}

- (IBAction)back_btn_action:(id)sender {
    DrugsListViewController *view=[self.storyboard instantiateViewControllerWithIdentifier:@"DrugsListViewController"];
    [self presentViewController:view animated:YES completion:nil];
}


- (UIImage *)quickResponseImageForString:(NSString *)dataString withDimension:(int)imageWidth {
    
    QRcode *resultCode = QRcode_encodeString([dataString UTF8String], 0, QR_ECLEVEL_L, QR_MODE_8, 1);
    
    unsigned char *pixels = (*resultCode).data;
    int width = (*resultCode).width;
    int len = width * width;
    
    if (imageWidth < width)
        imageWidth = width;
    
    // Set bit-fiddling variables
    int bytesPerPixel = 4;
    int bitsPerPixel = 8 * bytesPerPixel;
    int bytesPerLine = bytesPerPixel * imageWidth;
    int rawDataSize = bytesPerLine * imageWidth;
    
    int pixelPerDot = imageWidth / width;
    int offset = (int)((imageWidth - pixelPerDot * width) / 2);
    
    // Allocate raw image buffer
    unsigned char *rawData = (unsigned char*)malloc(rawDataSize);
    memset(rawData, 0xFF, rawDataSize);
    
    // Fill raw image buffer with image data from QR code matrix
    int i;
    for (i = 0; i < len; i++) {
        char intensity = (pixels[i] & 1) ? 0 : 0xFF;
        
        int y = i / width;
        int x = i - (y * width);
        
        int startX = pixelPerDot * x * bytesPerPixel + (bytesPerPixel * offset);
        int startY = pixelPerDot * y + offset;
        int endX = startX + pixelPerDot * bytesPerPixel;
        int endY = startY + pixelPerDot;
        
        int my;
        for (my = startY; my < endY; my++) {
            int mx;
            for (mx = startX; mx < endX; mx += bytesPerPixel) {
                rawData[bytesPerLine * my + mx    ] = intensity;    //red
                rawData[bytesPerLine * my + mx + 1] = intensity;    //green
                rawData[bytesPerLine * my + mx + 2] = intensity;    //blue
                rawData[bytesPerLine * my + mx + 3] = 255;          //alpha
            }
        }
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, rawData, rawDataSize, (CGDataProviderReleaseDataCallback)&freeRawData);
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef imageRef = CGImageCreate(imageWidth, imageWidth, 8, bitsPerPixel, bytesPerLine, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    
    UIImage *quickResponseImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    QRcode_free(resultCode);
    
    return quickResponseImage;
}

- (IBAction)push_button_action:(id)sender {
    if([self.selected_rx_id isEqualToString:@""]){
        return;
    }
    NSString *res=[Patient pushRx:self.selected_rx_id];
    if([res isEqualToString:@"success"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:@"Push successed!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

void freeRawData(void *info, const void *data, size_t size) {
    free((unsigned char *)data);
}

@end
