//
//  PAPMessageViewController.m
//  Anypic
//
//  Created by Sumit Ghosh on 03/09/14.
//
//

#import "PAPMessageViewController.h"
#import "PAPHomeViewController.h"
#import "VideoViewController.h"
#import "PAPTabBarController.h"

@interface PAPMessageViewController (){
    VideoViewController *videoPlay;
    NSMutableArray *users ;
    NSMutableArray *users1 ;
    
}
@property(nonatomic,strong)UIImageView * imgView;
@property(nonatomic,strong)UISegmentedControl * controller;
@property (nonatomic,strong)UIView * container;
//@property (nonatomic,strong)UIView * direct;
//@property (nonatomic,strong)UIView * follow;
@property (nonatomic,strong)NSMutableArray * searchResults;
@property (nonatomic,strong)NSArray * recipes;
@property (nonatomic,strong)NSMutableArray *friends;
@property (nonatomic,strong)NSMutableArray *friendsphoto;
@property (nonatomic,strong)NSMutableArray  * names, * names1, * allFrndsArray;
@property (nonatomic,strong)PFObject * obj;
@property (nonatomic,strong) UISearchBar * searchBar;
@property (nonatomic,assign) int  checkBoxSelected;
@property (nonatomic,strong) UITableView * tableView1;
@property (nonatomic, retain) NSMutableArray *selectedFriendsArray;
@property(nonatomic,strong)UISearchDisplayController *searchBarDC;
@property(nonatomic,strong) NSMutableDictionary * adict;
@property(nonatomic,assign) BOOL  srch;
@property(nonatomic,retain) UIButton * checkBox;

@end

@implementation PAPMessageViewController
@synthesize controller,videoFile,delegate;
@synthesize container,searchResults,recipes,names,obj,searchBar,tableView1,selectedFriendsArray,searchBarDC,allFrndsArray,friends,adict,srch,names1,checkBox,checkBoxSelected,imageSet;

- (id)initWithImage:(UIImage *)aImage {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        if (!aImage) {
            return nil;
        }
        
        image = aImage;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    recipes=[[NSArray alloc]init];
    users = [[NSMutableArray alloc]init] ;
    friends=[[NSMutableArray alloc]init];
    adict=[[NSMutableDictionary alloc]init];
  self.selectedFriendsArray = [[NSMutableArray alloc] init];
    allFrndsArray=[[NSMutableArray alloc]init];
    
    [self queryForTable];
   
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
     UIView * footerView=[[UIView alloc]initWithFrame:CGRectMake(0.0, self.view.bounds.size.height-90, self.view.bounds.size.width, 30)];
    footerView.backgroundColor= [UIColor colorWithRed:9/255.0 green:30/255.0 blue:59/255.0 alpha:1];
    [self.view addSubview:footerView];
    
    tableView1=[[UITableView alloc]initWithFrame:CGRectMake(0, 96, self.view.bounds.size.width,self.view.frame.size.height-185) style:UITableViewStylePlain];
    tableView1.delegate=self;
    tableView1.dataSource=self;
    tableView1.separatorColor= [UIColor colorWithRed:9/255.0 green:30/255.0 blue:59/255.0 alpha:0.5];;
    tableView1.backgroundColor=[UIColor colorWithRed:169.0/255.0 green:213.0/255.0 blue:248/255.0 alpha:0.5];
    [self.view addSubview:tableView1];
    
    self.imgView=[[UIImageView alloc]initWithFrame:CGRectMake(1, 5, 90, 90)];
    self.imgView.backgroundColor=[UIColor grayColor];
    self.imgView.image=image;
    self.imgView.layer.cornerRadius=5.0f;
    self.imgView.layer.borderColor=[UIColor grayColor].CGColor;
    self.imgView.layer.borderWidth=1.0;
    [self.view addSubview:self.imgView];
    [self.imgView setUserInteractionEnabled:YES];
//    [self.view bringSubviewToFront:self.imgView];

     UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.imgView addGestureRecognizer:tapGesture];
    
    textView1=[[UITextView alloc]initWithFrame:CGRectMake(92, 5, 230, 90)];
    textView1.delegate=self;
    textView1.backgroundColor=[UIColor colorWithRed:169.0/255.0 green:213.0/255.0 blue:248/255.0 alpha:0.5];
    textView1.text=@"Write a caption here..";
    [self.view addSubview:textView1];
    
    checkBoxSelected=1;
    checkBox=[[UIButton alloc]initWithFrame:CGRectMake(30,self.view.bounds.size.height-90, 30, 30) ];
    [checkBox addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchUpInside];
    [checkBox setImage:[UIImage imageNamed: @"unchecked-checkbox.png"] forState:UIControlStateNormal];
    [checkBox  setImage:[UIImage imageNamed: @"checked-checkbox.png"] forState:UIControlStateHighlighted];
    [checkBox setImage:[UIImage imageNamed:@"checked-checkbox.png"] forState:UIControlStateSelected];
    [self.view addSubview:checkBox];
    
    
    UILabel * lblSelect=[[UILabel alloc]initWithFrame:CGRectMake(70, self.view.bounds.size.height-98, 100, 50)];    [lblSelect setText:@"Select All"];
    [lblSelect setFont:[UIFont fontWithName:nil size:12.0]];
    [lblSelect setTextColor:[UIColor colorWithRed:32/255.0 green:143/255.0 blue:214/255.0 alpha:1]];
    [self.view addSubview:lblSelect];
    [self.view addSubview:tableView1];
    
    UISwipeGestureRecognizer *swipedown=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown:)];
    swipedown.numberOfTouchesRequired=1;
    swipedown.delegate=self;
    [self.view addGestureRecognizer:swipedown];
    
 }

- (void)cancelButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)handleSingleTap:(id)sender{
   
    if (!videoPlay) {
        videoPlay=[[VideoViewController  alloc] init];
    }
    [videoPlay playVideoWithUrl:self.videoUrl];
    [self.navigationController pushViewController:videoPlay animated:YES];

}


-(void)swipeDown:(id)sender{
    [textView1 resignFirstResponder];

}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if(textView==textView1)
    {   textView1.text=@"";
        
    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    if ([text isEqualToString:@"\n" ]) {
        [textView resignFirstResponder];
    }
    return YES;
}



- (PFQuery *)queryForTable {
    // Use cached facebook friend ids
    NSArray *facebookFriends = [[PAPCache sharedCache] facebookFriends];
    
    // Query for all friends you have on facebook and who are using the app
    NSLog(@"facebook friend %lu",(unsigned long)facebookFriends.count);
    PFQuery *friendsQuery = [PFUser query];
    [friendsQuery whereKey:kPAPUserFacebookIDKey containedIn:facebookFriends];
    
    
    // Combine the two queries with an OR
    PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:friendsQuery, nil]];
    query.cachePolicy = kPFCachePolicyNetworkOnly;
    
    //    if (self.objects.count == 0) {
    //        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    //    }
    friends=[[NSMutableArray alloc] init];
    images1=[[NSMutableArray alloc] init];
    //    NSLog(@"num of friends %ld",(long)recipes.count);
    names=[[NSMutableArray alloc]init];
    
    [query orderByAscending:kPAPUserDisplayNameKey];
    //    recipes=[query findObjects];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects,NSError *error){
        
        for (PFObject *obj1 in objects) {
            NSLog(@"obj1 is %@",obj1) ; 
           
            [users addObject:obj1];
           
          
            
            PFFile * fileimg=obj1 [kPAPUserProfilePicSmallKey];
            NSString *fbId=obj1[kPAPUserFacebookIDKey];
            NSString *name=obj1[kPAPUserDisplayNameKey];
            [fileimg getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if(!error)
                {
                    UIImage * image1=[UIImage imageWithData:data];
                    if(image1)
                    {
                        
                        [friends addObject:fbId];
                        [names addObject:name];
                        [images1 addObject:image1];
                    }
                }
                [tableView1 reloadData];
                
            }];
            
        }
        //        }
    }];
    return query;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    if(self.searchResults.count!=0){
        return  self.searchResults.count;
    }
    else
        return friends.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  40.0;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0;
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(40, 0, self.view.frame.size.width - 70, 30)];
    //tableHeaderView.backgroundColor =[UIColor grayColor];
    searchBox = [[UITextField alloc] initWithFrame:CGRectMake(1.0, 0, 248, 32)];
    searchBox.placeholder=@"   Search Friends here ";
    //[searchBox setBorderStyle:UITextBorderStyleLine];
    searchBox.backgroundColor = [UIColor whiteColor];
    [searchBox setBackgroundColor:[UIColor whiteColor]];
    searchBox.delegate=self;
    searchBox.layer.borderColor=[UIColor grayColor].CGColor;
    searchBox.layer.borderWidth=1.0f;
    searchBox.layer.cornerRadius=2.0f;
    [searchBox setFont:[UIFont boldSystemFontOfSize:15]];
    [searchBox setKeyboardType:UIKeyboardTypeAlphabet];
    
    
    
    UIButton * search=[[UIButton alloc]initWithFrame:CGRectMake(248.0, 0.0, 70, 32)];
    [search setTitle:@"Search" forState:UIControlStateNormal];
    search.backgroundColor=[UIColor colorWithRed:32/255.0 green:143/255.0 blue:214/255.0 alpha:1];
    [search addTarget:self action:@selector(searchBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    search.layer.cornerRadius=3.0f;
    [tableHeaderView addSubview:search];
    
    UIButton * cancel=[[UIButton alloc]initWithFrame:CGRectMake(220.0, 5.0, 25, 25)];
    //[cancel setTitle:@"C" forState:UIControlStateNormal];
    cancel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"mark.png"]];
    [cancel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [searchBox addSubview:cancel];
    
    
    
    [tableHeaderView addSubview:searchBox];
    return tableHeaderView;
}



-(void)searchBtnClicked{
    [searchBox endEditing:YES];
    NSLog(@"Search button clicked");
    NSString * str=searchBox.text;
    if([str isEqualToString:@""])
    {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:nil message:@"Please enter names to search"  delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        NSLog(@"Please Enter to Search");
    }
    else{
        srch=YES;
        [self filterContentForSearchText:str ];
    }
}
- (void)filterContentForSearchText:(NSString*)searchText
{
    searchImg =[[NSMutableArray alloc]init];
    serchFbid=[[NSMutableArray alloc]init];
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd]%@",searchText];
    self.searchResults= [NSMutableArray arrayWithArray: [names filteredArrayUsingPredicate:resultPredicate]];
    NSLog(@"search result count %lu",(unsigned long)self.searchResults.count);
    
    for(int i=0;i<names.count;i++)
    {
        for(int j=0;j<self.searchResults.count;j++)
        {
            if([searchResults[j] isEqualToString:names[i]])
            {
                [searchImg addObject:images1[i]];
                [serchFbid addObject:friends[i]];
            }
        }
    }
    
    [tableView1 reloadData];
}

-(void)cancelBtnClicked{
    srch=NO;
    [searchBox endEditing:YES];
    [self.searchResults removeAllObjects];
    [searchImg removeAllObjects];
    if(self.searchResults.count==0)
    {
    [tableView1 reloadData];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
   
    return  YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
   
     return  YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString * str=searchBox.text;
    [self filterContentForSearchText:str ];
    [searchBox resignFirstResponder];
    srch=YES;
    return YES;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.font=[UIFont systemFontOfSize:13.0f];
    if(searchImg.count!=0){
        cell.textLabel.text = [self.searchResults objectAtIndex:indexPath.row];
//        if(searchImg.count!=0)
//        {
            cell.imageView.image=[searchImg objectAtIndex:indexPath.row];
       // }
    } else {
        cell.textLabel.text =   [NSString stringWithFormat:@"%@",names[indexPath.row]];
        if(images1.count!=0)
        {
            cell.imageView.image=[images1 objectAtIndex:indexPath.row];
        }
    }
        @try {
        if ([self.selectedFriendsArray containsObject:indexPath]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception = %@",[exception name]);
    }
    
    cell.backgroundColor=[UIColor colorWithRed:169.0/255.0 green:213.0/255.0 blue:248/255.0 alpha:0.5];
    return  cell;
}
-(void)toggleButton:(UIButton * )button{
    if (checkBoxSelected==1) {
         [checkBox setSelected:YES];
        
      
            for (NSInteger r = 0; r < [self.tableView1 numberOfRowsInSection:0]; r++) {
                
            UITableViewCell *cell = [self.tableView1 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
      
        self.selectedFriendsArray=[NSMutableArray arrayWithArray:friends];
        checkBoxSelected=0;
    }
    else if (checkBoxSelected==0) {
        [checkBox setSelected:NO];
            for (NSInteger r = 0; r < [self.tableView1 numberOfRowsInSection:0]; r++) {
        UITableViewCell *cell = [self.tableView1 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:0]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
       checkBoxSelected=1;
        [ self.selectedFriendsArray removeAllObjects];
        NSLog(@"selected array %@",self.selectedFriendsArray);
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UIView animateWithDuration:.5 animations:^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }];
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    if (selectedCell.accessoryType==UITableViewCellAccessoryCheckmark) {
        selectedCell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectedFriendsArray removeObject:indexPath];
    }
    else{
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedFriendsArray addObject:indexPath];
    }
   
}

-(void) sendButtonClicked{
//    NSMutableString * selectdFriendsString=[[NSMutableString alloc]init];
    fbIdArray=[[NSMutableArray alloc] init];
    nameArray=[[NSMutableArray alloc] init];
    users1 = [[NSMutableArray alloc]init];
    if(srch==YES)
    {
            for(int i=0;i<selectedFriendsArray.count;i++)
        {
            NSIndexPath * path=self.selectedFriendsArray[i];
            NSLog(@"index path of row %ld",(long)path.row);
            NSString *strVal=[serchFbid objectAtIndex:path.row];
            NSString *str=[ self.searchResults objectAtIndex:path.row];
            NSString *userObject = [users objectAtIndex:path.row];
            
            [fbIdArray addObject:strVal];
            [nameArray addObject:str];
            [users1 addObject:userObject] ;
        }
        srch=NO;
    }
    else{
        if(checkBoxSelected==0)
        {
            for(int i=0;i<selectedFriendsArray.count;i++)
            {
                NSString *str=[names objectAtIndex:i];
                NSString *strVal=[friends objectAtIndex:i];
                NSString *userObject = [users objectAtIndex:i];
                [fbIdArray addObject:strVal];
                [nameArray addObject:str];
                [users1 addObject:userObject] ;
                
            }
        }
         else{
            
        
           for(int i=0;i<selectedFriendsArray.count;i++)
            {

             NSIndexPath * path=[selectedFriendsArray objectAtIndex:i];
             NSLog(@"index path of row %ld",(long)path.row);
             NSString *strVal=[friends objectAtIndex:path.row];
             NSString *str=[names objectAtIndex:path.row];
             NSString *userObject = [users objectAtIndex:path.row] ;
                [fbIdArray addObject:strVal];
                [nameArray addObject:str];
                [users1 addObject:userObject] ;
        }
    }
        srch=NO;
    
    }
    
    UIImage *resizedImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(560.0f, 560.0f) interpolationQuality:kCGInterpolationHigh];
      UIImage *thumbnailImage = [image thumbnailImage:86.0f transparentBorder:0.0f cornerRadius:10.0f interpolationQuality:kCGInterpolationDefault];
    
    
        // JPEG to decrease file size and enable faster uploads & downloads
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, 0.8f);
    NSData *thumbnailImageData = UIImagePNGRepresentation(thumbnailImage);
    
    photoFile = [PFFile fileWithData:imageData];
    thumbnailFile = [PFFile fileWithData:thumbnailImageData];

    [self oneToOneChat];
}


 -(BOOL)oneToOneChat{
     if (names.count==0) {
         UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Select Friends" message:@"from the list of following " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
         [alert show];
         return NO;
     }
    NSString *username=[[NSUserDefaults standardUserDefaults]objectForKey:@"connectedUserName"];
    NSString *fbid=[[NSUserDefaults standardUserDefaults]objectForKey:@"connectedUserFbid"];

    if (!photoFile||! thumbnailFile) {
        return NO;
    }
     for (int i=0; i<fbIdArray.count; i++) {
       
        // create a photo object
    PFObject *photo = [PFObject objectWithClassName:@"OneToOne"];
    [photo setObject:[PFUser currentUser] forKey:kPAPActivityFromUserKey];
    [photo setObject:fbIdArray[i] forKey:@"toUserFBID"];
    [photo setObject:fbid forKey:@"fromUserFBID"];
    [photo setObject:nameArray[i] forKey:@"toUserName"];
    [photo setObject:username forKey:@"fromUserName"];
    [photo setObject:@"No" forKey:@"Hide"];
          NSLog(@"user1 [i] is %@",users1 [ i]) ;
    [photo setObject:users1[i] forKey:@"toUser"]; // Set toUser
         
         NSLog(@"i is %d",i) ;
         NSLog(@"user [i] is %@",users [ i]) ;
        
         
         if (self.videoFile) {
             [photo setObject:self.videoFile forKey:kPAPPhotoPictureKey];
             [photo setObject:@"video" forKey:@"Type"];
         }
         else{
         
         [photo setObject:photoFile forKey:kPAPPhotoPictureKey];
         [photo setObject:@"image" forKey:@"Type"];

         }
         [photo setObject:thumbnailFile forKey:kPAPPhotoThumbnailKey];
         if(!([textView1.text isEqualToString:NULL]))
         { NSString * cmntstr=textView1.text;
         [photo setObject:cmntstr forKey:@"Message"];
         }
         
// photos are public, but may only be modified by the user who uploaded them
       // Save the Photo PFObject
         
    [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [[PAPCache sharedCache] setAttributesForPhoto:photo likers:[NSArray array] commenters:[NSArray array] likedByCurrentUser:NO];
            
                // userInfo might contain any caption which might have been posted by the uploader
            
            [[NSNotificationCenter defaultCenter] postNotificationName:PAPTabBarControllerDidFinishEditingPhotoNotification object:photo];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your photo" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
            [alert show];
        }
        
    }];
         
  }
     
     [self dismissViewControllerAnimated:YES completion:^{
          [[NSNotificationCenter defaultCenter] postNotificationName:@"callParent" object:nil];
     }];
    
     return YES;
         
}


@end
