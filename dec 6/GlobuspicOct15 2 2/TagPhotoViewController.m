//
//  TagPhotoViewController.m
//  Anypic
//
//  Created by Sumit on 14/10/14.
//
//

#import "TagPhotoViewController.h"
#import "PAPEditPhotoViewController.h"
#import "PAPHomeViewController.h"
#import "CustomTagLabel.h"

@interface TagPhotoViewController ()
{
    CGPoint touchLocation;
    NSInteger count;
    NSMutableArray *array1;
    CustomTagLabel *cLabel ;
}
@end

@implementation TagPhotoViewController
@synthesize imageView,headingLabel,tagLabel,whoIsThis,searchBox,searchBar,searchResults,srch,fbIdArray,searchImg,serchFbid,names,friends,tableView1,selectedFriendsArray,recipes,friendsphoto,images1,obj,tableHeaderView,search,cancel,whoText , close ,selectedRow,triangleButton,tagimage,delegate,filteredArray,userIDArray;

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
    selectedRow = NO ;
    count=0;
    array1=[[NSMutableArray alloc] init];
  self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
//    self.view.backgroundColor=  [UIColor colorWithRed:9/255.0 green:30/255.0 blue:59/255.0 alpha:1];
    if(!self.imageView)
    {
        self.imageView =[[UIImageView alloc] initWithFrame:CGRectMake(20, 100, 280, 260)];
        self.imageView.backgroundColor=[UIColor blackColor];
        [self.imageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        [self.imageView.layer setBorderWidth: 2.0];
        self.imageView.userInteractionEnabled =YES ;
        self.imageView.image =tagimage;
        [self.view addSubview:self.imageView];
    }
   
    headingLabel =[[UILabel alloc] initWithFrame: CGRectMake(100,55,150,50)];
    headingLabel.text = @"TAG PEOPLE";
    headingLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    headingLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:headingLabel];
    
    tagLabel =[[UILabel alloc] initWithFrame: CGRectMake(80,365,200,50)];
    tagLabel.text = @"Tag photo to tag people";
    tagLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
    tagLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:tagLabel];
    
    
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 375, self.view.frame.size.width, self.view.frame.size.height-375)];
    footerView.backgroundColor=[UIColor colorWithRed:9/255.0 green:30/255.0 blue:59/255.0 alpha:1];
    [self.view addSubview:footerView];
    
    
    tagLabel =[[UILabel alloc] initWithFrame: CGRectMake(70,35,200,50)];
    tagLabel.text = @"Tag photo to tag people";
    tagLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    tagLabel.textColor=[UIColor whiteColor];
    [footerView addSubview:tagLabel];

    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.imageView addGestureRecognizer:tapGesture];
    
    if (!tableView1) {
        tableView1=[[UITableView alloc]initWithFrame:CGRectMake(0, 65, self.view.bounds.size.width,self.view.frame.size.height-100) style:UITableViewStylePlain];
        tableView1.delegate=self;
        tableView1.dataSource=self;
        [self.view addSubview:tableView1];
    }
    tableView1.hidden = YES ;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]init];
    self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleBordered ;
    self.navigationItem.rightBarButtonItem.title = @"Done" ;
    self.navigationItem.rightBarButtonItem.target = self ;
   self.navigationItem.rightBarButtonItem.action = @selector(doneAction:);
    
    
    self.frameLocation =[[NSMutableArray alloc] init];
    self.filteredArray =[[NSMutableArray alloc] init];
      [self queryForTable];
   
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
    
   
    friends=[[NSMutableArray alloc] init];
    images1=[[NSMutableArray alloc] init];
    [query orderByAscending:kPAPUserDisplayNameKey];
    recipes=[query findObjects];
    NSLog(@"num of friends %ld",(long)recipes.count);
    names=[[NSMutableArray alloc]init];
    userIDArray = [[NSMutableArray alloc]init];
    self.friendsphoto=[[NSMutableArray alloc]init];
    
    for(int i=0;i<recipes.count;i++)
    {
        obj=[recipes objectAtIndex:i];
        NSLog(@"obj is %@",obj);
        NSLog(@"object detail %@",obj);
        [friends addObject:obj[kPAPUserFacebookIDKey]];
        [names addObject:obj[kPAPUserDisplayNameKey]];
        [userIDArray addObject:obj];
        [self.friendsphoto addObject:obj[kPAPUserProfilePicMediumKey]];
    }
    NSLog(@"user id array is %@",userIDArray);
    
    return query;
}

-(void)addSearchBox{
    
    self.searchBox = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 0.0, 150.0, 20)];
    self.searchBox.placeholder=@"   Search Friends here ";
    self.searchBox.backgroundColor = [UIColor whiteColor];
    self.searchBox.delegate=self;
     [searchBox  setBorderStyle:UITextBorderStyleRoundedRect];
    [self.searchBox setFont:[UIFont boldSystemFontOfSize:15]];
    [self.searchBox setKeyboardType:UIKeyboardTypeAlphabet];
    
    UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(0.0, 30.0, 150.0, 20)];
    [btn addSubview:searchBox];
    UIBarButtonItem * leftbtn=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=leftbtn;
    
    cancel=[[UIButton alloc]initWithFrame:CGRectMake(60.0, 0.0, 100, 25)];
    [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
 }

-(void)doneAction:(id)sender{
    //added no .
//    array1 = nil ;
//    [[NSUserDefaults standardUserDefaults]setObject:array1 forKey:@"SelectedRow"];
//    [[NSUserDefaults standardUserDefaults]synchronize ] ;
    
    tableView1.hidden = YES ;
    searchBox.hidden = YES ;
    [searchBox resignFirstResponder] ;
    [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"Tagged"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)searchBtnClicked{
    [searchBox endEditing:YES];
    tableView1.hidden = NO ;
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
    if(self.searchResults.count!=0)
    {
        for(int i=0;i<names.count;i++)
        {
            for(int j=0;j<self.searchResults.count;j++)
            {
                if([searchResults[j] isEqualToString:names[i]])
                {
                    [serchFbid addObject:friends[i]];
                }
            }
        }
    }
    else{
        NSLog(@"Enter for search");
    }
    [tableView1 reloadData];
}

-(void)cancelBtnClicked{

    self.imageView.hidden = NO ;
    tableView1.hidden = YES ;
    searchBox.hidden = YES ;
    whoIsThis.hidden = YES ;
    tableHeaderView.hidden =YES ;
    search.hidden= YES ;
    cancel.hidden =YES ;
    
    srch=NO;
    [searchBox endEditing:YES];
    [self.searchResults removeAllObjects];
    [searchImg removeAllObjects];
    if(self.searchResults.count==0)
    {
        [tableView1 reloadData];
    }

}
#pragma mark~tap action
#pragma mark ================

-(void)handleSingleTap:(id)sender{
    [tableView1 reloadData] ;
    tableView1.delegate = self ;
    [self addSearchBox] ;
    whoIsThis.hidden = NO ;
    
     touchLocation = [sender locationInView:self.imageView];
       NSLog(@"x is %f",touchLocation.x);
       NSLog(@"y is %f",touchLocation.y);
    
         whoIsThis = [UIButton buttonWithType:UIButtonTypeCustom];
        [whoIsThis setImage:[UIImage imageNamed:@"comment.png"] forState:UIControlStateNormal];
        [whoIsThis addTarget:self action:@selector(whoIsThisAction:)forControlEvents:UIControlEventTouchUpInside];
        [self.imageView addSubview:whoIsThis];
    
    
//   [whoIsThis addSubview:cLabel];
    
        //for extreme ends .
         if (touchLocation.x >199) {
         touchLocation.x=230 ;
           }
         if (touchLocation.y >250) {
         touchLocation.y = 250 ;
           }
    
     whoIsThis.frame = CGRectMake(touchLocation.x-30,touchLocation.y,70,30);
    
    if (touchLocation.x<25) {
         whoIsThis.frame = CGRectMake(touchLocation.x-5,touchLocation.y,70,30);
    }
    if (touchLocation.y<5) {
        whoIsThis.frame = CGRectMake(touchLocation.x,touchLocation.y,70,30);
    }
    if (touchLocation.y<5 && touchLocation.x >199) {
        touchLocation.x = 200 ;
        whoIsThis.frame = CGRectMake(touchLocation.x,touchLocation.y,70,30);
    }
    
    tableView1.hidden = YES ;
   [searchBox becomeFirstResponder] ;
    
    self.navigationItem.rightBarButtonItem.title = @"Cancel" ;
    self.navigationItem.rightBarButtonItem.target = self ;
    self.navigationItem.rightBarButtonItem.action = @selector(cancelAction:);
    
}

-(void)triangleButtonAction:(id)sender{
    NSLog(@"triangle button action") ;
    
}
-(void)cancelAction:(id)sender{
    if ([cLabel.text isEqualToString:@""]) {
        cLabel.hidden = YES ;
    }
    selectedRow = NO ;
    if (selectedRow == NO) {
        whoIsThis.hidden = YES ;
        whoIsThis = nil ;
        triangleButton.hidden =YES ;
        triangleButton = nil ;
    }
    NSLog(@"in cancel action") ;
    [searchBox resignFirstResponder] ;
    searchBox.hidden = YES ;
    tableView1.hidden = YES ;
    
    self.navigationItem.rightBarButtonItem.title = @"Done" ;
    self.navigationItem.rightBarButtonItem.target = self ;
    self.navigationItem.rightBarButtonItem.action = @selector(doneAction:);
    
}

-(void)closeAction:(id)sender{
    whoIsThis.hidden = YES ;
    triangleButton.hidden = YES ;
   
}


#pragma mark ~ table view delegate methods.
#pragma mark ---------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //added custom label .
    cLabel =[[CustomTagLabel alloc] initWithFrame: CGRectMake(touchLocation.x,touchLocation.y,90,30)];
    cLabel.hidden=NO;
    cLabel.layer.cornerRadius=5.0;
    cLabel.layer.backgroundColor=[UIColor blackColor].CGColor;
    cLabel.textColor=[UIColor whiteColor];
    
    [self.imageView addSubview:cLabel];

    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //added now .
    
    NSMutableArray * array2=[[NSUserDefaults standardUserDefaults]objectForKey:@"SelectedRow"];
    NSLog(@"array 2 did select row is %@",array2) ;
    
    if (!array2) {
        cell.userInteractionEnabled=YES;
        // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.enabled = YES ;
    }
    
    NSNumber * val = [NSNumber numberWithInteger:indexPath.row];
    
    if ([array2 containsObject:val]) {
        cell.userInteractionEnabled=NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        whoIsThis.frame = CGRectMake(touchLocation.x-30,touchLocation.y,70,30);
        cell.textLabel.enabled = NO ;
    }

    
    NSNumber *val1 = [NSNumber numberWithInteger:indexPath.row];
    [array1 addObject:val1];
    [[NSUserDefaults standardUserDefaults]setObject:array1 forKey:@"SelectedRow"];
    [[NSUserDefaults standardUserDefaults]synchronize ] ;
    
    selectedRow = YES ;
 
    
//    if(selectedRow == YES){
//        cell.userInteractionEnabled = NO;
//    }
    tableView1.hidden = YES ;
    searchBox.hidden = YES ;
    imageView.hidden = NO ;
    [searchBox resignFirstResponder] ;
    
    if (self.searchResults.count != 0 ) {
        NSString *search1 =self.searchResults[indexPath.row] ;
        NSArray *arr1 = [search1 componentsSeparatedByString:@" "];
        cLabel.text = arr1[0];
    }else{
        NSString * str =names[indexPath.row]  ;
        NSString *userId = userIDArray[indexPath.row];
        
        NSArray * arr = [str componentsSeparatedByString:@" "];
        NSLog(@"Array [0] is :%@",arr[0]);
        NSString * selected = arr[0] ;
        
        NSMutableDictionary *plist = [NSMutableDictionary dictionary];
        
        cLabel.text=selected;
        
        [plist setValue:[NSNumber numberWithFloat:touchLocation.x] forKey:@"Xposition"];
        [plist setValue:[NSNumber numberWithFloat:touchLocation.y] forKey:@"Yposition"];
        [plist  setObject:str forKey:@"name"];
        [plist setObject:userId forKey:@"user"];
        [self.frameLocation addObject:plist];
        
    }
    self.navigationItem.rightBarButtonItem.title = @"Done" ;
    self.navigationItem.rightBarButtonItem.target = self ;
    self.navigationItem.rightBarButtonItem.action = @selector(doneAction:);
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"cell";
    
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    //added now .
    
    NSMutableArray * array2=[[NSUserDefaults standardUserDefaults]objectForKey:@"SelectedRow"];
    NSLog(@"array 2 cellForRowAtIndexPath is %@",array2) ;
    
    if (!array2) {
        cell.userInteractionEnabled=YES;
       // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.enabled = YES ;
    }
    
    NSNumber * val = [NSNumber numberWithInteger:indexPath.row];
    
    if ([array2 containsObject:val]) {
        cell.userInteractionEnabled=NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.enabled = NO ;
    }
    
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font=[UIFont systemFontOfSize:14.0f];
    
    if(self.searchResults.count!=0){
        cell.textLabel.text = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.text =   [NSString stringWithFormat:@"%@",names[indexPath.row]];
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
    
//    cell.selectionStyle = UITableViewCellSelectionStyleGray ;
    return  cell;
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    searchBox.hidden = NO ;
    tableView1.hidden = NO ;
    self.imageView.hidden = NO;
    whoIsThis.hidden = NO ;
    
    return  YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
      return  YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
   // self.imageView.hidden = YES ;
    NSString * str=searchBox.text;
    [self filterContentForSearchText:str ];
    [searchBox resignFirstResponder];
    srch=YES;
    return YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
   /* for (int i=(int)[self.frameLocation count]-1; i>=0; i--) {
        //if ([self.frameLocation indexOfObject: [self.frameLocation objectAtIndex: i]]<i)
        for(NSDictionary * dict in self.frameLocation)
        {
            if([[dict objectForKey:@"name"]isEqualToString:[dict objectForKey:@"name"]])
            {
             [self.frameLocation removeObjectAtIndex: i];
            }
        }
        
    }*/
   // NSArray * setArray=[[NSSet setWithArray:self.frameLocation]allObjects];
    [delegate sendDataToA:self.frameLocation];
    
}


-(void)whoIsThisAction:(id)sender{
    NSLog(@"who is this action"); 
}

-(void) displaySelctedImage:(UIImage*) image{
    
    [self.imageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [self.imageView.layer setBorderWidth: 2.0];
    [self.view addSubview:self.imageView];
    self.imageView.image=image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
