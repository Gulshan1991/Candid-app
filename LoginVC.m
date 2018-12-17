//
//  LoginVC.m
//  Candid Connection
//
//  Copyright © 2018 Gulshan Solanki. All rights reserved.

#import "LoginVC.h"
#import "AFNetworking.h"
#import "ForgotPassword.h"
#import "IQKeyboardManager.h"
#import "UpdatePasword.h"
#import "ParseApi.h"
#import "Constants.h"
//#import "MBProgressHUD.h"
//#import "DGActivityIndicatorView.h"
@interface LoginVC ()<UserMgrDelegate>


@end

@implementation LoginVC

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(void)locationUpdation {
    if(self){
         CLLocationManager  *locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        [locationManager setDistanceFilter:kCLHeadingFilterNone];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [locationManager setPausesLocationUpdatesAutomatically:YES];
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
       
        
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    _txtpassword.delegate = self;
    _txtemail.delegate = self;

    
    // Do any additional setup after loading the view.
    CGRect frame = CGRectMake (0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:frame];
//    self.activityIndicatorView.color = [UIColor colorWithRed:210.0f/255.0f green:66.0f/255.0f blue:103/255.0f alpha:1.0f];
//    self.activityIndicatorView.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.5f];
//    [self.view addSubview:self.activityIndicatorView];
    
    [_btnlogn.layer setCornerRadius:25.0f];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    [self.txtemail layoutIfNeeded];
    [self.txtpassword layoutIfNeeded];
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 2;
    border.borderColor = [UIColor colorWithRed:210.0f/255.0f green:66.0f/255.0f blue:103/255.0f alpha:1.0f].CGColor;
    border.frame = CGRectMake(0, self.txtemail.frame.size.height - borderWidth, self.txtemail.frame.size.width, self.txtemail.frame.size.height);
    border.borderWidth = borderWidth;
    [self.txtemail.layer addSublayer:border];
    self.txtemail.layer.masksToBounds = YES;
    UIColor *color =  [UIColor colorWithRed:210.0f/255.0f green:66.0f/255.0f blue:103/255.0f alpha:1.0f];
    _txtemail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter your email address" attributes:@{NSForegroundColorAttributeName: color}];
    
    CALayer *border1 = [CALayer layer];
    CGFloat borderWidth1 = 2;
    border1.borderColor =  [UIColor colorWithRed:210.0f/255.0f green:66.0f/255.0f blue:103/255.0f alpha:1.0f].CGColor;
    border1.frame = CGRectMake(0, self.txtpassword.frame.size.height - borderWidth, self.txtpassword.frame.size.width, self.txtpassword.frame.size.height);
    border1.borderWidth = borderWidth1;
    [self.txtpassword.layer addSublayer:border1];
    self.txtpassword.layer.masksToBounds = YES;
    self.txtpassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter your password" attributes:@{NSForegroundColorAttributeName: color}];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    _txtpassword.leftView = paddingView;
    _txtpassword.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    _txtemail.leftView = paddingView1;
    _txtemail.leftViewMode = UITextFieldViewModeAlways;
    // Do any additional setup after loading the view.
    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"refresh"];

   
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _txtemail) {
        [_txtpassword becomeFirstResponder];
    }else if (textField == _txtpassword)
    {
        [_txtpassword resignFirstResponder];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:true];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:false];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)btnforgotpasswordClick:(id)sender {
    
    ForgotPassword * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPassword"];
    vc.screenNameValueOne = @"Back To Login";
    [self.navigationController pushViewController:vc animated:true];
    
}

- (IBAction)btnLoginClick:(id)sender {


    if(![self validateEmailWithString:_txtemail.text]){
        [self showAlert:@"Please enter valid email address."];
        return;
    }

    
    if ([_txtemail.text  isEqual: @""] || [_txtpassword.text  isEqual: @""]) {
         [self.activityIndicatorView stopAnimating];
        [self showAlert:@"Please enter your email address and password."];
        return;
    }
    [self startParsing];
    [self.activityIndicatorView startAnimating];

}

-(void)showAlert:(NSString*)message
{
    [sharedDelegate showfftoastalert:message withtoasttype:FFToastTypeInfo andtoastpostion:FFToastPositionBelowStatusBarWithFillet];
    
//    UIAlertController *alertController = [UIAlertController
//                                          alertControllerWithTitle:nil
//                                          message:message
//                                          preferredStyle:UIAlertControllerStyleAlert];
//
//    UIAlertAction *okAction = [UIAlertAction
//                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
//                               style:UIAlertActionStyleDefault
//                               handler:^(UIAlertAction *action)
//                               {
//                                   NSLog(@"OK action");
//                               }];
//
//    [alertController addAction:okAction];
//
//    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)addLoader
{
    [sharedDelegate showMBprogressLoader:self.view withtextmessage:@"Please wait..."];
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeCustomView;
//    hud.animationType = MBProgressHUDAnimationZoom;
//    hud.backgroundView.style = MBProgressHUDBackgroundStyleBlur;
//    hud.backgroundView.alpha = 0.4;
//    UIColor *color = [UIColor colorWithRed:210.0f/255.0f green:66.0f/255.0f blue:103/255.0f alpha:1.0f];
//    hud.customView = [[DGActivityIndicatorView alloc]
//                      initWithType:DGActivityIndicatorAnimationTypeCookieTerminator tintColor:color];
//    [(DGActivityIndicatorView*)hud.customView startAnimating];
//    hud.label.text = @"Please wait...";
//    hud.label.textColor = color;
//    hud.bezelView.backgroundColor = [UIColor whiteColor];
  //  hud.bezelView.backgroundColor = [UIColor colorWithWhite:210.0f/255.0f alpha:0.25];

    //hud.customView.layer.borderColor = [UIColor colorWithRed:210.0f/255.0f green:66.0f/255.0f blue:103/255.0f alpha:1.0f].CGColor;
//    CGRect cusreact = hud.customView.frame;
//    cusreact.size.height = 30;
//    hud.customView.frame = cusreact;
//    
//    CGRect boudsreact = hud.customView.bounds;
    
   
//    [(DGActivityIndicatorView*) hud.customView setFrame:CGRectMake(hud.customView.bounds.origin.x, hud.customView.bounds.origin.y, 90.f, 90.f)];
    
    //hud.square = true;
   // hud.customView.translatesAutoresizingMaskIntoConstraints = false;
  //   hud.customView.center = CGPointMake(hud.bezelView.center.x, hud.bezelView.center.y);
 
    
}

-(void)startParsing
{
      NSString *token =  [[NSUserDefaults standardUserDefaults]
                        stringForKey:@"deviceToken"];
   // [self showAlert:token];
        [self addLoader];
        ParseApi *obj = [[ParseApi alloc]init];
        obj.delegate = self;
        [obj callApi:[NSString stringWithFormat:@"%@%@",BaseUrl,LOGIN] parameters:[NSDictionary dictionaryWithObjectsAndKeys:_txtemail.text,@"userEmail",_txtpassword.text ,@"userPassword",@"I",@"device_type",token,@"device_token",nil] type:@"login" currentcontroller:self];
}

-(void)response:(NSDictionary*)responseobject type:(NSString *)type
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSLog(@"responseobject..%@",responseobject);
    NSDictionary *dict = [[NSDictionary alloc]initWithDictionary:responseobject];
    NSDictionary *data = [[NSDictionary alloc]initWithDictionary:dict];
    int success = [[NSString stringWithFormat:@"%@",dict [@"response"]]intValue];

    if (success==1) {
        NSString*userid = [NSString stringWithFormat:@"%@",data [@"data"] [@"user_id"]];
        [[NSUserDefaults standardUserDefaults] setObject:userid forKey:@"userid"];
        [[NSUserDefaults standardUserDefaults]setObject:@"loggedin" forKey:@"type"];
        [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"loggedin"];
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",data [@"data"] [@"UserChooseCategory"]]
                                                 forKey:@"selectedtags"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        [self performSegueWithIdentifier:@"gotomain" sender:nil];
    }else
    {

    
            NSString *errorMsg = [NSString stringWithFormat:@"%@",[dict objectForKey:@"message"]];
            [sharedDelegate showfftoastalert:errorMsg withtoasttype:FFToastTypeError andtoastpostion:FFToastPositionBelowStatusBarWithFillet];
//            UIAlertController *alert=   [UIAlertController
//                                         alertControllerWithTitle:errorMsg
//                                         message:nil
//                                         preferredStyle:UIAlertControllerStyleAlert];
//
//            [self presentViewController:alert animated:YES
//                             completion:nil];
        
            
            
            
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [alert dismissViewControllerAnimated:YES completion:^{
//                }];
//            });
    }
}


- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (IBAction)btnback:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
