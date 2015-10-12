//
//  ContactsAboutViewController.m
//  Дым
//
//  Created by Fenkins on 09/10/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "ContactsAboutViewController.h"
// PARSE COULD RETURN NULL RESULT(if keys got removed or smth), AND YOUR SUPPLEMENTARY CLASS WILL STORE THAT CRAP IN NSUSERDEFAULTS. FIX IT BEFORE RELEASE!
static const NSString* kCCnullStringPhrase = @"Сегодня мы работаем с (null) до (null)";
@interface ContactsAboutViewController ()
@end

@implementation ContactsAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.sheduleButtonLine && ![self.sheduleButtonLine isEqualToString:(NSString*)kCCnullStringPhrase]) {
        [self.sheduleButtonOutlet setTitle:self.sheduleButtonLine forState:UIControlStateNormal];
    }
    NSLog(@"%@",self.sheduleButtonLine);
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"sheduleButtonLineReceived: %@",self.sheduleButtonLine);
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

@end
