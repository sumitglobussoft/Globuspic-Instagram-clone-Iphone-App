//
//  InboxTableView.m
//  Anypic
//
//  Created by Globussoft 1 on 9/8/14.
//
//

#import "InboxTableView.h"
#import "customCell.h"
#import "PAPphotoViewController.h"
#import "VideoViewController.h"
#import  "SendMsgViewController.h"

@interface InboxTableView (){
    NSString * str;
    NSArray * arrUser;
    PFObject * inbxObj;
    NSString *fbid;
    VideoViewController *videoView;
    int skip ;
    int totalobj;
    int add;
    int count ;
   
}

@property(nonatomic,strong)NSMutableArray *checkTypeAry ;
@property(nonatomic,strong)NSMutableArray *imgVideoAry;
@property(nonatomic,strong)NSMutableArray *fromUserArray ;
@property(nonatomic,strong)NSMutableArray *toUserArray ;


@property(nonatomic,strong)NSMutableArray *imageArray, *objects;
@property(nonatomic,strong) NSMutableArray *allObjects ;
@property(nonatomic,strong)NSMutableArray *nameArray;
@property(nonatomic,strong)NSMutableArray *tonameArray;
@property(nonatomic,strong)NSMutableArray *dateArray;
@property(nonatomic,strong)NSMutableArray *downloadImage;
@property(nonatomic,strong)NSString *strtime,*message;
@property(nonatomic,strong) UILongPressGestureRecognizer * delete;
@property(nonatomic,strong)PAPphotoViewController * fullPhoto;
@end

@implementation InboxTableView

@synthesize delete, objects,refreshControl,message,followingActivitiesQuery,photosFromCurrentUserQuery,query,query1,allObjects,checkTypeAry,fromUserArray,toUserArray;

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
    count = 0 ;
   // [self displayBadges];
    self.imgVideoAry=[[NSMutableArray alloc] init];
    self.checkTypeAry=[[NSMutableArray alloc]init];
    self.fromUserArray=[[NSMutableArray alloc]init];
    self.toUserArray=[[NSMutableArray alloc]init];
    
    self.imageArray=[[NSMutableArray alloc] init];
    self.downloadImage=[[NSMutableArray alloc] init];
    self.tonameArray=[[NSMutableArray alloc] init];
    self.nameArray=[[NSMutableArray alloc] init];
    self.dateArray=[[NSMutableArray alloc] init];
    if (!timeFormatter) {
        timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
    }

    self.tableView1=[[UITableView alloc] initWithFrame:CGRectMake(0,15, 320,self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView1.dataSource=self;
    self.tableView1.delegate=self;
    [self.view addSubview:self.tableView1];
    [self retrieveOneToOneData];
    
//    [self.tableView1 reloadItemsAtIndexPaths:[self.tableView1 indexPathsForVisibleItems]];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refershControlAction) forControlEvents:UIControlEventValueChanged];
    [self.tableView1 addSubview:refreshControl];
    
   
    
    // Do any additional setup after loading the view.
}


- (void)refershControlAction
{
    NSLog(@"Reload grid");
    
    // The user just pulled down the collection view. Start loading data.
   // [self queryForTable];
    [refreshControl endRefreshing];

    [objects removeAllObjects];
    [self.tableView1 reloadData];
    }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject * obj=[objects objectAtIndex:indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {

    if([fbid isEqualToString:obj[@"toUserFBID"]])
    {
    [obj setObject:@"Yes" forKey:@"Hide"];
         [obj saveInBackground];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Delete" message:@"You can't see this post again after deleting" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        

    }
    if([fbid isEqualToString:obj[@"fromUserFBID"]])
    {
//        PFObject * obj=[objects objectAtIndex:indexPath.row];
        [obj deleteInBackground];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Delete" message:@"This message will permanently remove from you and from all your recipent also." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
        
        [self.nameArray removeObjectAtIndex:indexPath.row];
        [self.dateArray removeObjectAtIndex: indexPath.row];
        [self.tonameArray removeObjectAtIndex: indexPath.row];
        [self.downloadImage removeObjectAtIndex: indexPath.row];
        [self.imageArray removeObjectAtIndex:indexPath.row];
        [self.tableView1 reloadData];
            // Do whatever data deletion you need to do...
        
    }
    //[tableView endUpdates];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"image array count %lu",(unsigned long)self.imageArray.count);

    return self.imageArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"Cell";
        //
    customCell *cell = (customCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[customCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.userName.text=[self.imageArray objectAtIndex:indexPath.row ];
//    NSLog(@"indexpath.row is = = %ld",(long)indexPath.row) ;
     @try
    {
        // Attempt access to an empty array
        cell.photoDownloaded.image=[self.downloadImage objectAtIndex:indexPath.row];
        cell.toUserlabel.text=[self.tonameArray objectAtIndex:indexPath.row];
        cell.forShowingTime.text=[self.dateArray objectAtIndex:indexPath.row];
        cell.imageView.image=[self.nameArray objectAtIndex:indexPath.row];
        
    }
    @catch (NSException *exception)
    {
        // Print exception information
        NSLog( @"NSException caught" );
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
        return cell;
    }
    @finally
    {
        // Cleanup, in both success and fail cases
//        NSLog( @"In finally block");
        
//        [arraytest release];
    }
    return cell;

}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ((add%10)!= 0) {
        NSLog(@"in return");
        return ;
    }
    
    if ( add==indexPath.row+1) {
        skip = skip+ (int)self.objects.count ;
        
        NSLog(@"skip value is %d",skip);
        
        [self retrieveOneToOneData ];
        NSLog(@"called once");
    }
}
#pragma mark ~query for table
#pragma mark-----------------------


-(void)retrieveOneToOneData{
   
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.center=self.view.center;
    [activityView startAnimating];
    [self.view addSubview:activityView];
    
        fbid=[[PFUser currentUser]objectForKey:kPAPUserFacebookIDKey];
        
        if(!self.followingActivitiesQuery){
            self.followingActivitiesQuery = [PFQuery queryWithClassName:@"OneToOne"];
            [self.followingActivitiesQuery whereKey:@"toUserFBID" equalTo:fbid ];
            [ self.followingActivitiesQuery whereKey:@"Hide" equalTo:@"No" ];
        }
        
        if (! self.photosFromCurrentUserQuery) {
            self.photosFromCurrentUserQuery = [PFQuery queryWithClassName:@"OneToOne"];
            [self.photosFromCurrentUserQuery whereKey:@"fromUserFBID" equalTo:fbid];
        }
        
        if (!self.query) {
            self.query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:followingActivitiesQuery, photosFromCurrentUserQuery, nil]];
            [self.query orderByDescending:@"createdAt"];
            [self.query setCachePolicy:kPFCachePolicyNetworkOnly];
        }
        [self.query setLimit:10];
        
        NSLog(@"skip is %d",skip);
        
        [self.query setSkip:skip];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{

      
        objects=(NSMutableArray*)[self.query findObjects];
        
        
        NSLog(@"objects count is %lu",(unsigned long)objects.count) ;
        NSLog(@"allObjects count is %lu",(unsigned long)allObjects.count) ;
        
        add=add+(int)objects.count ;
        
        NSLog(@"objects count is %lu",(unsigned long)objects.count);
        
            for (int i=0; i<objects.count; i++) {
            [allObjects addObject:objects[i]];
            PFObject*  obj = [objects objectAtIndex:i];
            
            NSString *name=obj[@"fromUserName"];
            NSString *toName=obj[@"toUserName"];
            
            if(![fbid isEqualToString:obj[@"toUserFBID"]])
            {
                str=[NSString stringWithFormat:@"%@",obj[@"toUserFBID"]];
                NSLog(@"strfrom= %@",str);
            }
            
            if(![fbid isEqualToString:obj[@"fromUserFBID"]])
            {
                str=[NSString stringWithFormat:@"%@",obj[@"fromUserFBID"]];
                NSLog(@"strfrom= %@",str);
                
            }
            if (!self.query1) {
                self.query1=[PFQuery queryWithClassName:@"_User"];
                [ self.query1 whereKey:@"facebookId" equalTo:str];
                    arrUser=[ self.query1 findObjects];
                
            }
            [self.query1 setLimit:10];
            [self.query1 setSkip:skip];
            
            for (int i=0; i<arrUser.count; i++) {
                PFObject*  obj=[arrUser objectAtIndex:i];
                PFFile * frndFile=obj[kPAPUserProfilePicSmallKey];
                NSData *frndImageData=[frndFile getData];
                UIImage *frndimage =[UIImage imageWithData:frndImageData];
                [self.nameArray addObject:frndimage];
                
            }
            
            [self.tonameArray addObject:[NSString stringWithFormat:@"to %@",toName]];
            [self.imageArray addObject:[NSString stringWithFormat:@"From %@" ,name]];
            
            
            PFFile *userImageFile = obj[@"thumbnail"];
            PFFile *videoOrImg=obj[@"image"];
            NSString * checkType = obj[@"Type"];
            NSString *fromUser=obj[@"fromUserFBID"];
            NSString *toUser=obj[@"toUserFBID"];
            NSLog(@"checkType is %@",checkType);
            
            NSData *imageData=[userImageFile getData];
            UIImage *image =[UIImage imageWithData:imageData];
            self.strtime =[timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:[obj createdAt]];
            [self.imgVideoAry addObject:videoOrImg];
            [self.dateArray addObject:self.strtime];
            [self.downloadImage addObject:image];
            
            [self.checkTypeAry addObject:checkType];
            [self.fromUserArray addObject:fromUser];
            [self.toUserArray addObject:toUser];

                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView1 reloadData];
                    [activityView stopAnimating];
                });
        }
    });
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    
    [tableView reloadData] ;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"fbid is %@",fbid);
    NSLog(@"toUserArray[indexPath.row]] is %@",toUserArray[indexPath.row]);
    NSLog(@"fromUserArray[indexPath.row]] is %@",fromUserArray[indexPath.row]);
    
    [[NSUserDefaults standardUserDefaults]setObject:toUserArray[indexPath.row] forKey:@"toUser"];
    [[NSUserDefaults standardUserDefaults]synchronize] ;
    
    if(![fbid isEqualToString:toUserArray[indexPath.row]])
    {
        str=[NSString stringWithFormat:@"%@",toUserArray[indexPath.row]];
        NSLog(@"strfrom= %@",str);
    }
   
    if(![fbid isEqualToString:fromUserArray[indexPath.row]])
    {
        str=[NSString stringWithFormat:@"%@",fromUserArray[indexPath.row]];
        NSLog(@"strfrom= %@",str);
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"fbid"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSLog(@"self.imgVideo array is %lu",(unsigned long)self.imgVideoAry.count) ;
    NSLog(@"self.imgVideoAry data is %@",self.imgVideoAry[indexPath.row]);
    NSLog(@"self.checkTypeAry[indexPath.row] is %@",self.checkTypeAry[indexPath.row]);
   
    
    if ([self.checkTypeAry[indexPath.row]  isEqualToString: @"image"]) {
       
        if (!self.fullPhoto) {
            self.fullPhoto=[[PAPphotoViewController alloc]init];
        }
        
        self.fullPhoto.arrUser=arrUser;
        self.fullPhoto.message=message;
        PFFile *frndFile = [self.imgVideoAry objectAtIndex:indexPath.row] ;
        
        NSData *frndImageData=[frndFile getData];
        UIImage *frndimage =[UIImage imageWithData:frndImageData];
        self.fullPhoto.imageset=frndimage;
        [self.navigationController pushViewController:self.fullPhoto animated:YES];
       
    }
       else{
         PFFile *videoFile=self.imgVideoAry[indexPath.row];
        if (!videoView) {
             videoView=[[VideoViewController alloc] init];
        }
        NSLog(@"VideofileURL %@",videoFile.url);
        [videoView playVideoWithUrl:[NSURL URLWithString:videoFile.url]];
        [self.navigationController pushViewController:videoView animated:YES];
       }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 80.0;
}

@end
