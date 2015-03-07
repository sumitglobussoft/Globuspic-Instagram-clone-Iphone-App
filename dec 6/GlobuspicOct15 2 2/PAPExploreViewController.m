//
//  PAPExploreViewController.m
//  Anypic
//
//  Created by Globussoft 1 on 9/1/14.
//
//

#import "PAPExploreViewController.h"
#import "PAPphotoViewController.h"
#import "VideoViewController.h"
#import "ImageViewCustomCell.h"
#import "VideoViewController.h"
#import "SearchFriendsViewController.h"


//#import "PAPPhotoDetailsViewController"

@interface PAPExploreViewController ()

@property (nonatomic, strong) PAPphotoViewController *fullPhoto;
@property (nonatomic, strong) VideoViewController *videoVC;
@end

@implementation PAPExploreViewController
@synthesize wholeObj,refreshControl;


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
   // [self queryForTable];
   NSLog(@"Create UIcollectionView  Controller");

    UIBarButtonItem * leftTitle=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"logo1.png"] style:UIBarButtonItemStyleDone target:nil action:nil];
    UIBarButtonItem * rightBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search.png"] style:UIBarButtonItemStyleDone target:self action:@selector(searchBtnclicked)];
    
    self.navigationItem.rightBarButtonItem=rightBtn;
    self.navigationItem.leftBarButtonItem=leftTitle;
 
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];

    collectioView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [collectioView setDataSource:self];
    [collectioView setDelegate:self];
    [collectioView registerClass:[ImageViewCustomCell class] forCellWithReuseIdentifier:@"cell"];
    [collectioView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    [self.view addSubview:collectioView];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 100)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [collectioView setCollectionViewLayout:flowLayout];
    collectioView.delegate=self;
    collectioView.dataSource=self;
    [self.view addSubview:collectioView];
    
   // [collectioView reloadItemsAtIndexPaths:[collectioView indexPathsForVisibleItems]];
    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refershControlAction) forControlEvents:UIControlEventValueChanged];
    [collectioView addSubview:refreshControl];
    
    [self queryForTable];
    
    // Do any additional setup after loading the view.
}
- (void)refershControlAction
{
    NSLog(@"Reload grid");
    
    // The user just pulled down the collection view. Start loading data.
    [self queryForTable];
    [refreshControl endRefreshing];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return imageArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * identifier=@"cell";
    
   
  ImageViewCustomCell * cell=(ImageViewCustomCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.imageView.image=[imageArray objectAtIndex:indexPath.row];
    
    return cell;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Indexpath.row %lu",(long)indexPath.row);
    PFObject *object = [wholeObj objectAtIndex:indexPath.row];
    NSString *type = object[@"Type"];
    
    if ([type isEqualToString:@"image"]) {
        if (!self.fullPhoto) {
           
            self.fullPhoto=[[PAPphotoViewController alloc] init];
        }
        
        self.fullPhoto.imageset=[imageArray objectAtIndex:indexPath.row];
       // [self.fullPhoto displaySelctedImage:[imageArray objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:self.fullPhoto animated:YES];
    }
    else if ([type isEqualToString:@"Video"]){
     
        NSLog(@"Video Selected");
        PFFile *videoFile = object[@"image"];
        NSURL *url = [NSURL URLWithString:videoFile.url];
        
        if (!self.videoVC) {
            self.videoVC = [[VideoViewController alloc] init];
        }
        [self.videoVC playVideoWithUrl:url];
        
        [self.navigationController pushViewController:self.videoVC animated:YES];
    }
    
    
    }

- (void )queryForTable {
    //NSMutableArray *array;
    
        // Query for the friends the current user is following
    PFQuery *followingActivitiesQuery = [PFQuery queryWithClassName:kPAPActivityClassKey];
    [followingActivitiesQuery whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeFollow];
    [followingActivitiesQuery whereKey:kPAPActivityFromUserKey equalTo:[PFUser currentUser]];
    
        // Using the activities from the query above, we find all of the photos taken by
        // the friends the current user is following
    PFQuery *photosFromFollowedUsersQuery = [PFQuery queryWithClassName:@"Photo"];
    [photosFromFollowedUsersQuery whereKey:kPAPPhotoUserKey matchesKey:kPAPActivityToUserKey inQuery:followingActivitiesQuery];
    [photosFromFollowedUsersQuery whereKeyExists:kPAPPhotoPictureKey];
    
        // We create a second query for the current user's photos
    PFQuery *photosFromCurrentUserQuery = [PFQuery queryWithClassName:@"Photo"];
    [photosFromCurrentUserQuery whereKey:kPAPPhotoUserKey equalTo:[PFUser currentUser]];
    [photosFromCurrentUserQuery whereKeyExists:kPAPPhotoPictureKey];
    
        // We create a final compound query that will find all of the photos that were
        // taken by the user's friends or by the user
    PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:photosFromFollowedUsersQuery, photosFromCurrentUserQuery, nil]];
    [query includeKey:kPAPPhotoUserKey];
    [query orderByDescending:@"createdAt"];
    
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        NSArray *ary = [query findObjects];
        imageArray = [[NSMutableArray alloc]init];
        wholeObj = [[NSMutableArray alloc] init];
      //  NSLog(@"ary = %@",ary);
        for (int i = 0; i < ary.count; i++) {
            
            PFObject *obj = [ary objectAtIndex:i];
            
            
            for (PFObject * participant in ary) {
                if ([participant[@"Type"] isEqual:@"Video"])
                {
                    [videoObj addObject:participant];
                }
                // [objectIds addObject:participant.objectId];
            }
            
            
            PFFile *userImageFile = obj[@"thumbnail"];
            
            [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:imageData];
                    
                    //  NSLog(@"image is %@",image);
                    if(image)
                    {
                    [imageArray addObject:image];
                    [wholeObj addObject:obj];
                    //NSLog(@"image is %@",image);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [collectioView reloadData];
                    });
                    }
                    //use this image array to set in the imageview .
                    
                    
                }
            }];
            
        }// ENd First For loop
        
    });
    
   }

#pragma - mark Search Button

-(void)searchBtnclicked{
    if (!searchFriends) {
         searchFriends =[[PAPSearchFriendsViewController alloc]init];
    }
   
        [self.navigationController pushViewController:searchFriends animated:YES];
   
    
}

@end
