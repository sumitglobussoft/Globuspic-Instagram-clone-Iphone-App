//
//  VideoViewController.m
//  Anypic
//
//  Created by Globussoft 1 on 9/2/14.
//
//

#import "VideoViewController.h"
#import "PAPPhotoDetailsHeaderView.h"

@interface VideoViewController ()

@property (nonatomic, strong) UITextField *commentTextField;
@property (nonatomic, strong) PAPPhotoDetailsHeaderView *headerView;
@property (nonatomic, assign) BOOL likersQueryInProgress;

@end

@implementation VideoViewController
@synthesize commentTextField,headerView,strUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    // Do any additional setup after loading the view.
}

-(void) playVideoWithUrl:(NSURL *)videoUrl{
    
    if (!self.videoPlayWebView) {
        self.videoPlayWebView = [[UIWebView alloc]initWithFrame:CGRectMake(20, 70, 280,330)];
        [self.view addSubview:self.videoPlayWebView];
    }
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:videoUrl];
    [self.videoPlayWebView loadRequest:nsrequest];
    
}

-(void) viewWillDisappear:(BOOL)animated{
    [self.videoPlayWebView stopLoading];
}

-(void)viewDidAppear:(BOOL)animated{

   }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) myMovieFinishedCallback: (NSNotification*) aNotification
{
    [self dismissMoviePlayerViewControllerAnimated];
    NSLog(@"my moview is playing from my movie player");
        // Release the movie instance created in playMovieAtURL:
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
