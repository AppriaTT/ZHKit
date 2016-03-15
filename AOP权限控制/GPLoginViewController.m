//
//  GPLoginViewController.m
//  03-aop权限控制
//
//  Created by 哲 肖 on 15/12/23.
//  Copyright (c) 2015年 肖喆. All rights reserved.
//

#import "GPLoginViewController.h"

@interface GPLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation GPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeTouch:)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)closeTouch:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)loginButtonTouch:(id)sender {
    
    NSString * name = self.nameTextField.text;
    //
    NSUserDefaults * df = [NSUserDefaults standardUserDefaults];
    [df setObject:name forKey:@"name"];
    [df synchronize];
    
    [self closeTouch:nil];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
