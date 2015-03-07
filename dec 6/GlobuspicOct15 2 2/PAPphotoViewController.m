//
//  PAPphotoViewController.m
//  Anypic
//
//  Created by Globussoft 1 on 9/1/14.
//
//

#import "PAPphotoViewController.h"
#import "SendMsgViewController.h"
@interface PAPphotoViewController ()
{
    SendMsgViewController * sendMsg;
    UIScrollView * scrollView;
    CGRect footerRect ;
}


@end

@implementation PAPphotoViewController
@synthesize imageset,arrUser,navController,url,message,commentTextField;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initWithanImage:(UIImage *)image1
{
    imageset=image1;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"message is %@",message);
    
    scrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:scrollView];
    
      self.navController = [[UINavigationController alloc] init];
    
    UIButton * back=[[UIButton alloc]initWithFrame:CGRectMake(5.0, 10.0, 50, 50)];
    [back setTitle:@"Back" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * left=[[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem=left;
    
    
    
   self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    
    fbid=[[NSUserDefaults standardUserDefaults]objectForKey:@"fbid"];
    
    if (![fbid isEqualToString:@"0"]) {
         self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStyleDone target:self action:@selector(replyButtpnAction)];
    }
    if(!self.imageView)
    {
    self.imageView =[[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 280, 280)];
    self.imageView.backgroundColor=[UIColor blackColor];
    [self.imageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [self.imageView.layer setBorderWidth: 2.0];
    [scrollView addSubview:self.imageView];
    }
    
   [self imageDetails];
    [scrollView setContentSize:CGSizeMake(scrollView.bounds.size.width, scrollView.bounds.size.height*1.1)];

}
- (CGFloat)textViewHeightForAttributedText:(NSAttributedString *)text andWidth:(CGFloat)width
{
//    UITextView *textView = [[UITextView alloc] init];
    [caption setAttributedText:text];
    CGSize size = [caption sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}

-(void)viewDidAppear:(BOOL)animated{
    [self imageDetails];
}

-(void)imageDetails{

    if(!([message isEqualToString:@"Write a caption here.."]||[message isEqualToString:@""])&& message!=nil)
    {
        caption=[[UITextView alloc]initWithFrame:CGRectMake(20, 290, 280, 35)];
        caption.layer.cornerRadius=4.0f;
        caption.delegate=self;
        caption.text=message;
        caption.backgroundColor=[UIColor whiteColor];
        [caption setEditable:NO];
        [scrollView addSubview:caption];
    }
    
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [caption resignFirstResponder];
    return YES ;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [caption resignFirstResponder];
    return YES;
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.imageView.image=self.imageset; 
}
-(void) displaySelctedImage:(UIImage*) image{
    
    //if (!self.imageView) {
        //self.imageView =[[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 280, 280)];
        [self.imageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        [self.imageView.layer setBorderWidth: 2.0];
        [scrollView addSubview:self.imageView];
   // }
    self.imageView.image=image;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)replyButtpnAction{
    BOOL cameraDeviceAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    BOOL photoLibraryAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    if(cameraDeviceAvailable && photoLibraryAvailable)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Photo", nil];
        [actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
    }
    else{
        [self shouldStartPhotoLibraryPickerController];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self shouldStartCameraController];
    } else if (buttonIndex == 1) {
        [self shouldStartPhotoLibraryPickerController];
    }
    else if(buttonIndex == 2)
    {
        [self shouldStartCameraControllerVideo];
    }
    else if (buttonIndex ==3)
    {
        [self shouldStartPhotoLibraryPickerControllerVideo];
    }
}


- (BOOL)shouldStartCameraController {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]
        && [[UIImagePickerController availableMediaTypesForSourceType:
             UIImagePickerControllerSourceTypeCamera] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        } else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        
    } else {
        return NO;
    }
    
    cameraUI.allowsEditing = YES;
    cameraUI.showsCameraControls = YES;
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:YES completion:nil];
    
    return YES;
}



- (BOOL)shouldStartPhotoLibraryPickerController {
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO
         && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)) {
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
        && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]
               && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        
    } else {
        return NO;
    }
    
    cameraUI.allowsEditing = YES;
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:YES completion:nil];
    return YES;
}


- (BOOL)shouldStartPhotoLibraryPickerControllerVideo {
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO
         && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)) {
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
        && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary] containsObject:(NSString *)kUTTypeMovie]) {
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeMovie];
        
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]
               && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum] containsObject:(NSString *)kUTTypeMovie]) {
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeMovie];
        
    } else {
        return NO;
    }
    
    cameraUI.allowsEditing = YES;
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:YES completion:nil];
    
    return YES;
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if(image)
    {
        [self dismissViewControllerAnimated:NO completion:nil];
        
      sendMsg  = [[SendMsgViewController alloc] initWithImage:image];
      
        [self.navController pushViewController:sendMsg animated:NO];
        [self presentViewController:self.navController animated:YES completion:nil];
    }
   
}


- (BOOL)shouldStartCameraControllerVideo {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]
        && [[UIImagePickerController availableMediaTypesForSourceType:
             UIImagePickerControllerSourceTypeCamera] containsObject:(NSString *)kUTTypeMovie]) {
        
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeMovie];
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        } else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        
    } else {
        return NO;
    }
    
    cameraUI.allowsEditing = YES;
    cameraUI.showsCameraControls = YES;
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:YES completion:nil];
    
    return YES;
}

-(void)backBtnClicked{
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"fbid"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    //[self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
